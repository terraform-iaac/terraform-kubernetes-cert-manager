terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.11.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    template = {
      source = "hashicorp/template"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
  required_version = ">= 0.13"
}