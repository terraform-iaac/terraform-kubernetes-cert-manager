locals {
  name               = var.name
  namespace          = var.namespace
  annotations        = var.annotations
  labels             = var.labels
  secret_name        = var.secret_name
  secret_annotations = var.secret_annotations
  secret_labels      = var.secret_labels
  duration           = var.duration
  renew_before       = var.renew_before
  organizations      = var.organizations
  # The use of the common name field has been deprecated sicne 2000 and is
  # discouraged from being used
  # common_name           = var.common_name
  is_ca                 = var.is_ca
  private_key_algorithm = var.private_key_algorithm
  private_key_encoding  = var.private_key_encoding
  private_key_size      = var.private_key_size
  usages                = var.usages
  dns_names             = var.dns_names
  uris                  = var.uris
  ip_addresses          = var.ip_addresses
  issuer_name           = var.issuer_name
  issuer_kind           = var.issuer_kind
  issuer_group          = var.issuer_group
}
