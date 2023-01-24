terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
  }
  required_version = ">= 1.0.0"
}