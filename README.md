Terraform module for Kubernetes Cert Manager
==========================================

Terraform module used to create Cert Manager in Kubernetes, with auto http validation issuer. With simple syntax.

## Usage

### You should to add into your terraform, `kubectl` & `helm`  provider configuration:
```terraform
provider "kubectl" {
  # Same config as in kubernetes provider
}
provider "helm" {
  kubernetes {
    # Same config as in kubernetes provider
  }
}
provider "kubernetes" {
  # configuration
}
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.1"
    }
  }
}
```

#### To activate TLS auto generation, please add this annotation to ingress:
    cert-manager.io/cluster-issuer = module.cert_manager.cluster_issuer_name

#### Terraform example
```terraform
module "cert_manager" {
  source        = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email                   = "admin@mysite.com"
  cluster_issuer_name                    = "cert-manager-global"
  cluster_issuer_private_key_secret_name = "cert-manager-private-key"
}

```

## Inputs

| Name | Description | Type | Default |  Required |
|------|-------------|------|---------|:--------:|
| namespace\_name  | Name of created namespace | `string` | `cert-manager` | no |
| chart\_version  | HELM Chart Version for cert-manager ( It is not recommended to change )| `string` | `cert-manager` | no |
| create_namespace | Create namespace or use exist | `bool` | `true` | no |
| cluster\_issuer\_server | The ACME server URL | `string` | `https://acme-v02.api.letsencrypt.org/directory` | no |
| cluster\_issuer\_email | Email address used for ACME registration | `string` | n/a |  yes |
| cluster\_issuer\_private\_key\_secret\_name | Name of a secret used to store the ACME account private key | `string` | `cert-manager-private-key` |  no |
| cluster\_issuer\_name | Cluster Issuer Name, used for annotations | `string` | `cert-manager` |  no |
| cluster\_issuer\_create | Create Cluster Issuer? Note: you should create your own issuer if value `false` | `bool` | `true` |  no |
| cluster\_issuer\_yaml | Create Cluster Issuer with your yaml. NOTE: some variables stop to work in case when you using this parameter | `string` | `null` |  no |
| additional\_set | Additional sets to Helm | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string // Optional<br>  }))</pre> | `[]` |  no |
| solvers | Alternate way of providing just the solvers section of the cluster issuer | `list[object(any)]` | <pre>- http01:<br>    ingress:<br>      class: nginx</pre>|  no |
| certificates | List of certificates | `any` | refer to ["Certificates"](#certificates) |

### Solvers
An example of a complex solver that uses different methods `http01` and `DNS01` as well as selectors for different domains would be
```
solvers = [
  {
    dns01 = {
      route53 = {
        region  = "us-east-1"
        ambient = "true"
      }
    },
    selector = {
      dnsZones = [
        "internal.example.com"
      ]
    }
  },
  {
    dns01 = {
      cloudflare = {
        email = "user@example.com"
        apiKeySecretRef = {
          name = "cloudflare-api-key-secret"
          key  = "API"
        }
      },
    },
    selector = {
      dnsZones = [
        "public.example.com"
      ]
    }
  },
  {
    http01 = {
      ingress = {
        class = "nginx"
      }
    }
  }
]
```


### Certificates

```hcl
module "cert_manager" {
  ...
  certificates = {
    "my_certificate" = {
      dns_names = ["my.example.com"]
    }
  }
}
```


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| namespace | certificate resource namespace | string | uses var.namespace_name of this module | no |
| secret_name | certificate secret name. Note: for AKS/AGIC ensure cert and secret have the same name | string | ${Certificate Name}-tls | no |
| secret_annotations | certificate secret annotations | map(string) | {} | no |
| secret_labels | certificate secret labels | map(string) | {} | no |
| duration | certificate validity period | map(string) | "2160h" | no |
| renew_before | It will reissue the certificate before this date from the due date | string | "360h" | no |
| organizations | Organization of issuing certificate | list(string) | [] | no |
| is_ca | Whether the certificate is a CA or not | bool | false | no |
| private_key_algorithm | It will generate a private key with this algorithm | string | "RSA" | no |
| private_key_encoding | It will generate a private key with this encoding | string | "PKCS1" | no |
| private_key_size | It will generate a private key of this lengh | number | 2048 | no |
| usages | certificate usages | list(string) | ["server auth", "client auth"] | no |
| dns_names | Domain names for which the certificate is intended | list(string) | n/a | yes |
| uris | certificate URIs | list(string) | [] | no |
| ip_addresses | certificate ip address | list(string) | [] | no |
| issuer_name | issuer name.  | string | Default is the name of the ClusterIssuer created by this module | no |
| issuer_kind | issuer kind | string | "ClusterIssuer" | no |
| issuer_group | issuer group | string | "" | no |


## Outputs
| Name | Description |
|------|:-----------:|
| namespace | Namespace used by cert manager |
| cluster\_issuer\_name | Created cluster issuer |
| cluster\_issuer\_server | ACME Server used by Cluster Issuer |
| cluster\_issuer\_private\_key\_name | Name of secrets, where cert manager stores private key | 
| certificates[*].map | Certificate settings applied to k8s |
| certificates[*].secret_name | Secret name of the certificate |

## Terraform Requirements

| Name | Version   |
|------|-----------|
| terraform | >= 1.0.0  |
| kubernetes | >= 2.0.1  |
| helm | >= 2.5.0  |
| gavinbunney/kubectl | >= 1.13.0 |

Cert Manager Version: v1.11.0

Source: https://github.com/jetstack/cert-manager

Tutorials: https://cert-manager.io/docs/
