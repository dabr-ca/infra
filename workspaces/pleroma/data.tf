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

data "aws_caller_identity" "current" {}

data "aws_sns_topic" "default_cloudwatch" {
  name = "Default_CloudWatch_Alarms_Topic"
}
