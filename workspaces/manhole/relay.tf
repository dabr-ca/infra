locals {
  relay_domain = "relay-test.dabr.ca"
}

resource "aws_lb_listener_rule" "relay" {
  listener_arn = data.aws_lb_listener.main_https.arn

  condition {
    host_header {
      values = [local.relay_domain]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.relay.arn
  }
}

resource "aws_lb_target_group" "relay" {
  name     = "${local.name}-relay-test"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_lb_target_group_attachment" "relay" {
  target_group_arn = aws_lb_target_group.relay.arn
  target_id        = aws_instance.manhole.id
}

resource "aws_route53_record" "relay" {
  zone_id = data.aws_route53_zone.main.id
  name    = local.relay_domain
  type    = "A"

  alias {
    zone_id                = data.aws_lb.main.zone_id
    name                   = data.aws_lb.main.dns_name
    evaluate_target_health = false
  }
}
