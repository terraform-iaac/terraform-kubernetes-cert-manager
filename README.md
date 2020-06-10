### Terraform K8S module for Automatically provision and manage TLS certificates in Kubernetes

#### Step to activate custom provider:
    1. Install custom provider from templates/kubectl-plugin.sh 
    
        bash: '/bin/bash terraform_k8s_cert_manager/templates/kubectl-plugin.sh'
        
    2. Add provider configuration to terraform (The provider supports the same configuration parameters as the Kubernetes Terraform Provider )
    
        provider "kubectl" {
          host                   = var.eks_cluster_endpoint
          cluster_ca_certificate = base64decode(var.eks_cluster_ca)
          token                  = data.aws_eks_cluster_auth.main.token
          load_config_file       = false
        }

#### For activate auto generating TLS, please add this annotation to ingress:
        cert-manager.io/cluster-issuer: CLUSTER_ISSUER_NAME #(Default: cert-manager)

Custom Provider: https://gavinbunney.github.io/terraform-provider-kubectl/docs/provider.html

Cert Manager Version: v0.15.1

Source: https://github.com/jetstack/cert-manager

Tutorials: https://cert-manager.io/docs/