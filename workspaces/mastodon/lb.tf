resource "aws_lb" "main" {
  name_prefix = local.name
  subnets     = data.terraform_remote_state.vpc.outputs.subnet_ids.public[*]
}

resource "aws_lb_listener" "main_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "main_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws.aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = ""
  }
}

resource "aws_lb_target_group" "main" {
  name_prefix = local.name
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.main.id
}
