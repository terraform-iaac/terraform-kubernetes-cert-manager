variable "name" {
  type        = string
  description = "certificate resource name"
}

variable "namespace" {
  type        = string
  description = "certificate resource namespace"
  default     = "cert-manager"
}

variable "annotations" {
  type        = map(string)
  description = "certificate resource annotations"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "certificate labels"
  default     = {}
}

variable "secret_name" {
  type        = string
  description = "certificate secret name"
}

variable "secret_annotations" {
  type        = map(string)
  description = "certificate secret annotations"
  default     = {}
}

variable "secret_labels" {
  type        = map(string)
  description = "certificate secret labels"
  default     = {}
}

variable "duration" {
  type        = string
  description = "certificate duration"
  default     = "2160h" # 90d
}

variable "renew_before" {
  type        = string
  description = "certificate renew before"
  default     = "360h" # 15d
}

variable "organizations" {
  type        = list(string)
  description = "certificate organizations"
  default     = []
}

variable "is_ca" {
  type        = bool
  description = "is CA certificate"
  default     = false
}

variable "private_key_algorithm" {
  type        = string
  description = "certificate private key algorithm"
  default     = "RSA"
}

variable "private_key_encoding" {
  type        = string
  description = "certificate private key encoding"
  default     = "PKCS1"
}

variable "private_key_size" {
  type        = number
  description = "certificate private key size"
  default     = 2048
}

variable "usages" {
  type        = list(string)
  description = "certificate usages"
  default     = ["server auth", "client auth"]
}

variable "dns_names" {
  type        = list(string)
  description = "certificate dns names"
}

variable "uris" {
  type        = list(string)
  description = "certificate uris"
  default     = []
}

variable "ip_addresses" {
  type        = list(string)
  description = "certificate ip addresses"
  default     = []
}

variable "issuer_name" {
  type        = string
  description = "issuer name"
}

variable "issuer_kind" {
  type        = string
  description = "issuer name"
}

variable "issuer_group" {
  type        = string
  description = "issuer group"
  default     = ""
}
