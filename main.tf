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
}

resource "time_sleep" "wait" {
  create_duration = "60s"

  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_manifest" "cluster_issuer" {
  count = var.cluster_issuer_create ? 1 : 0

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = var.cluster_issuer_name
    }

    spec = {
      acme = {
        server         = var.cluster_issuer_server
        preferredChain = "ISRG Root X1"
        email          = var.cluster_issuer_email
        privateKeySecretRef = {
          name = var.cluster_issuer_private_key_secret_name
        }
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }

  depends_on = [kubernetes_namespace.cert_manager, helm_release.cert_manager, time_sleep.wait]
}