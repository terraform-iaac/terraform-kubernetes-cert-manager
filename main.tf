resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name      = "cert-manager"
    }
    name        = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.id
  version    = "1.0.3"

  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubectl_manifest" "cluster_issuer" {
  count      = var.cluster_issuer_create ? 1 : 0

  validate_schema = false

  yaml_body  = var.cluster_issuer_yaml == null ? data.template_file.cluster_issuer.rendered : var.cluster_issuer_yaml

  depends_on = [kubernetes_namespace.cert_manager, helm_release.cert_manager]
}