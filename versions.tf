terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
  required_version = ">= 0.14"
}