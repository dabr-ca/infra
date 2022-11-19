terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.39.0"
    }
  }

  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "tfc"
    }
  }
}
