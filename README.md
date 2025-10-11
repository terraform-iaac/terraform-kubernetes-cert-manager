Terraform module for Kubernetes Cert Manager
==========================================

Terraform module for deploying Cert Manager in Kubernetes with automatic certificate validation via HTTP ClusterIssuer.  
Provides a simple and flexible interface.

## Usage

### Required Providers & Configuration
Make sure to configure the following providers in your root Terraform module:
```terraform
provider "kubectl" {
  # Same config as in kubernetes provider
}
provider "helm" {
  kubernetes = {
    # Same config as in kubernetes provider
  }
}
provider "kubernetes" {
  # configuration
}
terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
    }
  }
}
```

#### Minimal Example

This is the minimal configuration required to deploy cert-manager and create a working ClusterIssuer for HTTP validation.

```terraform
module "cert_manager" {
  source               = "terraform-iaac/cert-manager/kubernetes"
  cluster_issuer_email = "admin@mysite.com"
}
```

### Enable Automatic TLS on Ingress

To enable automatic TLS certificate generation for your Ingress resources, add the following annotation to use default TLS issuer:

```yaml
cert-manager.io/cluster-issuer = module.cert_manager.cluster_issuer_name
```

By default, the module uses a built-in HTTP solver with the ingress class set to `"nginx"`:
```hcl
solvers = [{
  http01 = {
    ingress = {
      ingressClassName = "nginx"
    }
  }
}]
```

This means your default Ingress controller must be named "nginx".
If your cluster uses a different ingress class (e.g. "alb", "traefik", etc),
you should override the solvers variable to match your setup.

```hcl
solvers = [{
  http01 = {
    ingress = {
      ingressClassName = "your-ingress-class"
    }
  }
}]
```

### Solvers
An example of a complex solver that uses different methods `http01` and `DNS01` as well as selectors for different domains would be
```hcl
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
        ingressClassName = "nginx"
      }
    }
  }
]
```

## Inputs

### General Settings
| Name                     | Description                                                                           | Type                                                                                                            | Default -                                | Required |
|--------------------------|---------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|------------------------------------------|:--------:|
| namespace\_name          | Name of created namespace                                                             | `string`                                                                                                        | `cert-manager`                           |    no    |
| create\_namespace        | Whether to create the namespace or use an existing one                                | `bool`                                                                                                          | `true`                                   |    no    |
| chart\_version           | HELM Chart Version for cert-manager ( It is not recommended to change )               | `string`                                                                                                        | `1.17.2`                                 |    no    |
| crds                     | This option decides if the CRDs should be installed as part of the Helm installation  | bool                                                                                                            | true                                     |    no    |
| crds_keep                | This will prevent Helm from uninstalling the CRD when the Helm release is uninstalled | bool                                                                                                            | true                                     |    no    |
| additional\_set          | Additional sets to Helm                                                               | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string // Optional<br>  }))</pre> | `[]`                                     |    no    |
| certificates             | List of certificates                                                                  | `any`                                                                                                           | refer to ["Certificates"](#certificates) |    no    |

### ClusterIssuer Configuration
| Name                                        | Description                                                                                                     | Type                | Default -                                                  | Required |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------|---------------------|------------------------------------------------------------|:--------:|
| cluster\_issuer\_email                      | Email address used for ACME registration                                                                        | `string`            | n/a                                                        |    yes    |
| cluster\_issuer\_server                     | The ACME server URL                                                                                             | `string`            | `https://acme-v02.api.letsencrypt.org/directory`           |    no     |
| cluster\_issuer\_preferred\_chain           | Preferred chain for ClusterIssuer                                                                               | `string`            | `ISRG Root X1`                                             |    no     |
| cluster\_issuer\_private\_key\_secret\_name | Name of a secret used to store the ACME account private key                                                     | `string`            | `cert-manager-private-key`                                 |    no     |
| cluster\_issuer\_name                       | Cluster Issuer Name, used for annotations                                                                       | `string`            | `cert-manager`                                             |    no     |
| cluster\_issuer\_create                     | Create Cluster Issuer? Note: you should create your own issuer if value `false`                                 | `bool`              | `true`                                                     |    no     |
| cluster\_issuer\_yaml                       | Create Cluster Issuer with your yaml. NOTE: some variables stop to work in case when you using this parameter   | `string`            | `null`                                                     |    no     |
| solvers                                     | Alternate way of providing just the solvers section of the cluster issuer                                       | `list[object(any)]` | <pre>- http01:<br>    ingress:<br>      ingressClassName: nginx</pre> |    no     |


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

| Name                  | Description                                                                           | Type         | Default                                                         |  Required  |
|-----------------------|---------------------------------------------------------------------------------------|--------------|-----------------------------------------------------------------|:----------:|
| dns_names             | Domain names for which the certificate is intended                                    | list(string) | n/a                                                             |    yes     |
| namespace             | certificate resource namespace                                                        | string       | uses var.namespace_name of this module                          |     no     |
| labels                | certificate resource labels                                                           | map(string)  | {}                                                              |     no     |
| secret_name           | certificate secret name. Note: for AKS/AGIC ensure cert and secret have the same name | string       | ${Certificate Name}-tls                                         |     no     |
| secret_annotations    | certificate secret annotations                                                        | map(string)  | {}                                                              |     no     |
| secret_labels         | certificate secret labels                                                             | map(string)  | {}                                                              |     no     |
| duration              | certificate validity period                                                           | map(string)  | "2160h"                                                         |     no     |
| renew_before          | It will reissue the certificate before this date from the due date                    | string       | "360h"                                                          |     no     |
| organizations         | Organization of issuing certificate                                                   | list(string) | []                                                              |     no     |
| is_ca                 | Whether the certificate is a CA or not                                                | bool         | false                                                           |     no     |
| private_key_algorithm | It will generate a private key with this algorithm                                    | string       | "RSA"                                                           |     no     |
| private_key_encoding  | It will generate a private key with this encoding                                     | string       | "PKCS1"                                                         |     no     |
| private_key_size      | Length of the generated private key                                                   | number       | 2048                                                            |     no     |
| usages                | certificate usages                                                                    | list(string) | ["server auth", "client auth"]                                  |     no     |
| uris                  | certificate URIs                                                                      | list(string) | []                                                              |     no     |
| ip_addresses          | certificate ip address                                                                | list(string) | []                                                              |     no     |
| issuer_name           | issuer name.                                                                          | string       | Default is the name of the ClusterIssuer created by this module |     no     |
| issuer_kind           | issuer kind                                                                           | string       | "ClusterIssuer"                                                 |     no     |
| issuer_group          | issuer group                                                                          | string       | ""                                                              |     no     |

## Outputs
| Name                                | Description                                            |
|-------------------------------------|--------------------------------------------------------|
| namespace                           | Namespace used by cert manager                         |
| cluster\_issuer\_name               | Created cluster issuer                                 |
| cluster\_issuer\_server             | ACME Server used by Cluster Issuer                     |
| cluster\_issuer\_private\_key\_name | Name of secrets, where cert manager stores private key | 
| certificates[*].map                 | Certificate settings applied to k8s                    |
| certificates[*].secret_name         | Secret name of the certificate                         |

## Terraform Requirements

| Name          | Version  |
|---------------|:--------:|
| terraform     | >= 1.0.0 |
| kubernetes    |   ~> 2   |
| helm          |   ~> 3   |
| alekc/kubectl |   ~> 2   |

Cert Manager HELM Chart version: v1.19.0: https://artifacthub.io/packages/helm/cert-manager/cert-manager

Source: https://github.com/jetstack/cert-manager


Tutorials: https://cert-manager.io/docs/
