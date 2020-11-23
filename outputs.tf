output "namespace" {
  value = kubernetes_namespace.cert_manager.id
}
output "cluster_issuer_name" {
  value = var.cluster_issuer_name
}
output "cluster_issuer_server" {
  value = var.cluster_issuer_server
}
output "cluster_issuer_private_key_name" {
  value = var.cluster_issuer_private_key_secret_name
}