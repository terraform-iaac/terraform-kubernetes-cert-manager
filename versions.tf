terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2"
    }
  }
}