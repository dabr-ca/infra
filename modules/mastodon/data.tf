data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "dabr-ca"
    workspaces = {
      name = "vpc"
    }
  }
}

data "terraform_remote_state" "s3" {
  backend = "remote"

  config = {
    organization = "dabr-ca"
    workspaces = {
      name = "s3"
    }
  }
}

data "aws_key_pair" "main" {
  key_name = var.ec2_key_name
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_acm_certificate" "main" {
  domain      = var.domain
  key_types   = ["EC_prime256v1"]
  most_recent = true
}

data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
