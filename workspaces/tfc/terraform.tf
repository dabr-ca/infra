terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.39.0"
    }
  }
  backend "s3" {
    bucket = "tfstates-fdf62903"
    key    = "workspaces/tfc/terraform.tfstate"
    region = "us-west-2"
  }
}
