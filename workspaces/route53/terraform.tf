terraform {
  required_version = ">= 1.5.5"
  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "route53"
    }
  }
}
