locals {
  domain = "dabr.ca"
}

resource "aws_route53_zone" "main" {
  name = local.domain
}

# Set up MX to receive emails
resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.main.id

  name = local.domain
  type = "MX"
  ttl  = 300
  records = [
    "10 in1-smtp.messagingengine.com.",
    "20 in2-smtp.messagingengine.com.",
  ]
}

# Status page
resource "aws_route53_record" "status" {
  zone_id = aws_route53_zone.main.id

  name    = "status.${local.domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["statuspage.betteruptime.com"]
}
