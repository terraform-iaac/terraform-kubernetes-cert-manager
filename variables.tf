variable "namespace_name" {
  default = "cert-manager"
}

variable "create_namespace" {
  type        = bool
  description = "(Optional) Create namespace?"
  default     = true
}

variable "chart_version" {
  type        = string
  description = "HELM Chart Version for cert-manager"
  default     = "1.11.0"
}

variable "cluster_issuer_server" {
  description = "The ACME server URL"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cluster_issuer_preferred_chain" {
  description = "Preferred chain for ClusterIssuer"
  default     = "ISRG Root X1"
  type        = string
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
  type        = list(any)
  description = "Additional sets to Helm"
  default     = []
}

variable "solvers" {
  description = "List of Cert manager solvers. For a complex example please look at the Readme"
  type        = any
  default = [{
    http01 = {
      ingress = {
        class = "nginx"
      }
    }
  }]
}

variable "certificates" {
  description = "List of Certificates"
  type        = any
  default     = {}
}
