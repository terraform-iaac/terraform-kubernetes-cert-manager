variable "namespace_name" {
  default = "cert-manager"
}

variable "cluster_issuer_server" {
  description = "The ACME server URL"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cluster_issuer_email" {
  description = "Email address used for ACME registration"
  type        = string
}

variable "cluster_issuer_private_key_secret_name" {
  description = "Name of a secret used to store the ACME account private key"
  type        = string
  default     = "cert-manager-private-key"
}

variable "cluster_issuer_name" {
  description = "Cluster Issuer Name, used for annotations"
  type        = string
  default     = "cert-manager"
}

variable "cluster_issuer_create" {
  description = "Create Cluster Issuer"
  type        = bool
  default     = true
}

variable "cluster_issuer_yaml" {
  description = "Create Cluster Issuer with your yaml"
  type        = string
  default     = null
}

variable "additional_set" {
  description = "Additional sets to Helm"
  default     = []
}