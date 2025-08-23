resource "aws_lb_target_group" "metrics" {
  name     = "${local.name}-metrics"
  port     = 4021
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    path    = "/metrics"
    matcher = "200,401"
  }
}

resource "aws_lb_target_group_attachment" "metrics" {
  target_group_arn = aws_lb_target_group.metrics.arn
  target_id        = aws_instance.main.id
}

resource "aws_lb_listener_rule" "metrics" {
  listener_arn = aws_lb_listener.main_https.arn

  condition {
    host_header {
      values = [var.domain]
    }
  }
  condition {
    path_pattern {
      values = ["/metrics"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metrics.arn
  }
}

resource "random_uuid" "prometheus_token" {}

resource "aws_ssm_parameter" "prometheus_token" {
  name  = "/${local.name}/prometheus_token"
  type  = "SecureString"
  value = random_uuid.prometheus_token.result
}

resource "aws_ssm_parameter" "grafana_cloud_token" {
  name  = "/${local.name}/grafana_cloud_token"
  type  = "SecureString"
  value = "." # populate this value manually

  lifecycle {
    ignore_changes = [value]
  }
}
