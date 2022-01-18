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
  default     = "1.6.1"
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

variable "solvers" {
  description = "List of Cert manager solvers"
  type        = any
  default = [{
    http01 = {
      ingress = {
        class = "nginx"
      }
    }
  }]
  #
  # Example from https://github.com/terraform-iaac/terraform-kubernetes-cert-manager/issues/5
  #
  # [
  #   {
  #     dns01 = {
  #       route53 = {
  #         region  = "us-east-1"
  #         ambient = "true"
  #       }
  #     },
  #     selector = {
  #       dnsZones = [
  #         "internal.example.com"
  #       ]
  #     }
  #   },
  #   {
  #     dns01 = {
  #       cloudflare = {
  #         email = "user@example.com"
  #         apiKeySecretRef = {
  #           name = "cloudflare-api-key-secret"
  #           key  = "API"
  #         }
  #       },
  #     },
  #     selector = {
  #       dnsZones = [
  #         "public.example.com"
  #       ]
  #     }
  #   },
  #   {
  #     http01 = {
  #       ingress = {
  #         class = "nginx"
  #       }
  #     }
  #   }
  # ]
}
