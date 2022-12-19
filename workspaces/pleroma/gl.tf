# Set up glitch-lily as an alternative FE. This is not considered a part of
# Pleroma so it's not codified in the module.

locals {
  gl_domain = "gl.${local.domain}"
}

data "aws_lb_listener" "main_https" {
  load_balancer_arn = module.pleroma.lb.arn
}

data "aws_lb_target_group" "main" {
  name = local.name
}

resource "aws_lb_listener_rule" "gl" {
  listener_arn = data.aws_lb_listener.main_https.arn

  condition {
    host_header {
      values = [local.gl_domain]
    }
  }

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.main.arn
  }
}

resource "aws_route53_record" "gl" {
  zone_id = data.aws_route53_zone.main.id
  name    = local.gl_domain
  type    = "A"

  alias {
    zone_id                = module.pleroma.lb.zone_id
    name                   = module.pleroma.lb.dns_name
    evaluate_target_health = false
  }
}
