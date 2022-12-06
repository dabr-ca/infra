terraform {
  required_version = ">= 1.2.9"
  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "pleroma"
    }
  }
}
