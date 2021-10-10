module "cert_manager" {
  source                                 = "../"
  cluster_issuer_email                   = "admin@mysite.com"
  cluster_issuer_name                    = "cert-manager-dev"         // optional
  cluster_issuer_private_key_secret_name = "cert-manager-private-key" // optional
}