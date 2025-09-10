data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_key_pair" "main" {
  key_name = var.ec2_key_name
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }
}

data "aws_route53_zone" "main" {
  name = var.domain
}
