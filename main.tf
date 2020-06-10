resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name      = "cert-manager"
    }
    name        = "cert-manager"
  }
}

resource "kubectl_manifest" "cert_manager" {
  yaml_body  = file("${path.module}/templates/cert-manager.yaml")

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubectl_manifest" "cluster_issuer" {
  count      = var.cluster_issuer_create ? 1 : 0

  yaml_body  = var.cluster_issuer_yaml == null ? data.template_file.cluster_issuer.rendered : var.cluster_issuer_yaml

  depends_on = [kubernetes_namespace.cert_manager, kubectl_manifest.cert_manager]
}