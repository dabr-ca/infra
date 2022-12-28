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
