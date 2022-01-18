locals {
  cluster_issuer = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.cluster_issuer_name
    }
    spec = {
      acme = {
        # The ACME server URL
        server         = var.cluster_issuer_server
        preferredChain = "ISRG Root X1"
        # Email address used for ACME registration
        email = var.cluster_issuer_email
        # Name of a secret used to store the ACME account private key
        privateKeySecretRef = {
          name = var.cluster_issuer_private_key_secret_name
        }
        # Enable the HTTP-01 challenge provider
        solvers = var.solvers
      }
    }
  }
}
