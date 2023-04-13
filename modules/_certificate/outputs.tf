output "map" {
  value = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name        = var.name
      namespace   = var.namespace
      annotations = var.annotations
    }
    spec = {
      secretName = var.secret_name

      secretTemplate = {
        annotations = var.secret_annotations
        labels      = var.secret_labels
      }

      duration    = var.duration
      renewBefore = var.renew_before
      subject = {
        organizations = var.organizations
      }
      isCA = var.is_ca
      private_key = {
        algorithm = var.private_key_algorithm
        encoding  = var.private_key_encoding
        size      = var.private_key_size
      }
      usages      = var.usages
      dnsNames    = var.dns_names
      uris        = var.uris
      ipAddresses = var.ip_addresses
      issuerRef = {
        name  = var.issuer_name
        kind  = var.issuer_kind
        group = var.issuer_group
      }
    }
  }
}

output "secret_name" {
  value = var.secret_name
}
