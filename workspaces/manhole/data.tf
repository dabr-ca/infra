data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "dabr-ca"
    workspaces = {
      name = "vpc"
    }
  }
}

data "aws_route53_zone" "main" {
  name = local.domain
}

data "aws_lb" "main" {
  name = local.name
}

data "aws_lb_listener" "main_https" {
  load_balancer_arn = data.aws_lb.main.arn
  port              = 443
}

data "aws_ami" "ubuntu22" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
