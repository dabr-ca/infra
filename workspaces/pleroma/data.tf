data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstates-fdf62903"
    key    = "workspaces/vpc/terraform.tfstate"
    region = "us-west-2"
  }
}

data "aws_lb_listener" "main_https" {
  load_balancer_arn = module.pleroma.lb.arn
  port              = 443
}

data "aws_caller_identity" "current" {}

data "aws_sns_topic" "default_cloudwatch" {
  name = "Default_CloudWatch_Alarms_Topic"
}
