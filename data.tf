data "template_file" "cluster_issuer" {
  template = file("${path.module}/templates/cluster-issuer.yaml")

  vars = {
    email                   = var.cluster_issuer_email
    server                  = var.cluster_issuer_server
    namespace               = kubernetes_namespace.cert_manager.id
    name                    = var.cluster_issuer_name
    private_key_secret_name = var.cluster_issuer_private_key_secret_name
  }
}