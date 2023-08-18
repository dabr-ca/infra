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

# Set up DKIM for FastMail
# NOTE: SPF is set up in ../pleroma
resource "aws_route53_record" "dkim" {
  for_each = toset(["fm1", "fm2", "fm3"])

  zone_id = aws_route53_zone.main.id
  name    = "${each.key}._domainkey.${local.domain}."
  type    = "CNAME"
  ttl     = "300"
  records = ["${each.key}.${local.domain}.dkim.fmhosted.com."]
}

# Status page
resource "aws_route53_record" "status" {
  zone_id = aws_route53_zone.main.id

  name    = "status.${local.domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["statuspage.betteruptime.com"]
}
