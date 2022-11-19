terraform {
  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "vpc"
    }
  }
}
