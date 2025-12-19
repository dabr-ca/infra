terraform {
  required_version = ">= 1.5.5"
  backend "s3" {
    bucket = "tfstates-fdf62903"
    key    = "workspaces/route53/terraform.tfstate"
    region = "us-west-2"
  }
}
