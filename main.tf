resource "kubernetes_namespace" "cert_manager" {
  count = var.create_namespace ? 1 : 0

  metadata {
    annotations = {
      name = var.namespace_name
    }
    name = var.namespace_name
  }
}

resource "helm_release" "cert_manager" {
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  name       = "cert-manager"
  namespace  = var.create_namespace ? kubernetes_namespace.cert_manager[0].id : var.namespace_name
  version    = var.chart_version

  create_namespace = false

  set = concat(
    [
      {
        name  = "crds.enabled"
        value = var.crds
      },
      {
        name = "crds.keep"
        value = var.crds_keep
      }
    ],
    var.additional_set
  )
}

resource "time_sleep" "wait" {
  create_duration = "60s"

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "cluster_issuer" {
  count = var.cluster_issuer_create ? 1 : 0

  validate_schema = false

  yaml_body = var.cluster_issuer_yaml == null ? yamlencode(local.cluster_issuer) : var.cluster_issuer_yaml

  depends_on = [kubernetes_namespace.cert_manager, helm_release.cert_manager, time_sleep.wait]
}

module "certificates" {
  for_each = { for k, v in var.certificates : k => v }
  source   = "./modules/_certificate"

  name                  = each.key
  namespace             = try(each.value.namespace, var.namespace_name)
  annotations           = try(each.value.annotations, {})
  labels                = try(each.value.labels, {})
  secret_name           = try(each.value.secret_name, "${each.key}-tls")
  secret_annotations    = try(each.value.secret_annotations, {})
  secret_labels         = try(each.value.secret_labels, {})
  duration              = try(each.value.duration, "2160h")
  renew_before          = try(each.value.renew_before, "360h")
  organizations         = try(each.value.organizations, [])
  is_ca                 = try(each.value.is_ca, false)
  private_key_algorithm = try(each.value.private_key_algorithm, "RSA")
  private_key_encoding  = try(each.value.private_key_encoding, "PKCS1")
  private_key_size      = try(each.value.private_key_size, 2048)
  usages                = try(each.value.usages, ["server auth", "client auth", ])
  dns_names             = each.value.dns_names
  uris                  = try(each.value.uris, [])
  ip_addresses          = try(each.value.ip_addresses, [])
  issuer_name           = try(each.value.issuer_name, var.cluster_issuer_name)
  issuer_kind           = try(each.value.issuer_kind, "ClusterIssuer")
  issuer_group          = try(each.value.issuer_group, "")
}


resource "kubectl_manifest" "certificates" {
  for_each = { for k, cc in module.certificates : k => cc }

  validate_schema = false

  yaml_body = yamlencode(each.value.map)

  depends_on = [kubectl_manifest.cluster_issuer]
}
