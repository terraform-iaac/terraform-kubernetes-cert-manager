module "cert_manager" {
  source = "../"

  cluster_issuer_email = "admin@mysite.com"

  additional_set = [
    {
      name  = "podDnsPolicy"
      value = "None"
    },
    {
      name  = "podDnsConfig.nameservers[0]"
      value = "8.8.8.8"
    },
    {
      name  = "podDnsConfig.nameservers[1]"
      value = "1.1.1.1"
    },
    {
      name  = "extraArgs[0]"
      type  = "string"
      value = "--dns01-recursive-nameservers-only"
    },
    {
      name  = "extraArgs[1]"
      type  = "string"
      value = "--dns01-recursive-nameservers=8.8.8.8:53\\,1.1.1.1:53"
    },
  ]
}