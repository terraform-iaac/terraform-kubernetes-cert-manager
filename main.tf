resource "kubernetes_namespace" "cert_manager" {
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
  namespace  = kubernetes_namespace.cert_manager.id
  version    = "1.5.3"

  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  dynamic "set" {
    for_each = var.additional_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "time_sleep" "wait" {
  create_duration = "60s"

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "cluster_issuer" {
  count = var.cluster_issuer_create ? 1 : 0

  validate_schema = false

  yaml_body = var.cluster_issuer_yaml == null ? data.template_file.cluster_issuer.rendered : var.cluster_issuer_yaml

  depends_on = [kubernetes_namespace.cert_manager, helm_release.cert_manager, time_sleep.wait]
}