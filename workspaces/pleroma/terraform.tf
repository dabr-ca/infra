terraform {
  required_version = ">= 1.2.9"
  backend "s3" {
    bucket = "tfstates-fdf62903"
    key    = "workspaces/pleroma/terraform.tfstate"
    region = "us-west-2"
  }
}
