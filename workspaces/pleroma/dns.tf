# Set up MX to receive emails
resource "aws_route53_record" "google_domains_mx" {
  zone_id = data.aws_route53_zone.main.id

  name = local.domain
  type = "MX"
  ttl  = 300
  records = [
    "5 gmr-smtp-in.l.google.com.",
    "10 alt1.gmr-smtp-in.l.google.com.",
    "20 alt2.gmr-smtp-in.l.google.com.",
    "30 alt3.gmr-smtp-in.l.google.com.",
    "40 alt4.gmr-smtp-in.l.google.com.",
  ]
}

# Status page
resource "aws_route53_record" "status" {
  zone_id = data.aws_route53_zone.main.id

  name    = "status.${local.domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["statuspage.betteruptime.com"]
}
