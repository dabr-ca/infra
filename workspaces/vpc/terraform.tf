terraform {
  backend "s3" {
    bucket = "tfstates-fdf62903"
    key    = "workspaces/vpc/terraform.tfstate"
    region = "us-west-2"
  }
}
