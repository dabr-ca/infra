locals {
  name          = "main"
  cidr_block    = "10.31.0.0/16"
  subnets       = cidrsubnets(local.cidr_block, 4, 4, 4, 4, 4, 4)
  subnet_groups = chunklist(local.subnets, 3)
}

module "vpc" {
  source = "../../modules/vpc"

  name = local.name
  cidr = local.cidr_block

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = local.subnet_groups[0]
  public_subnets  = local.subnet_groups[1]

  enable_nat_gateway            = false
  single_nat_gateway            = true
  manage_default_security_group = true
}

resource "aws_key_pair" "tarball" {
  key_name   = "wzyboy@tarball"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDB3eYUem12rVaP+2ijbGqFqTM4bfnYcYmHjDq7j6IjT wzyboy@tarball"
}
