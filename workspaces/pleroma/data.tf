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

data "aws_lb_listener" "main_https" {
  load_balancer_arn = module.pleroma.lb.arn
  port              = 443
}
