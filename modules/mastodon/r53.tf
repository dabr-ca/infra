resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "files" {
  for_each = toset(["A", "AAAA"])

  zone_id = aws_route53_zone.main.id
  name    = var.files_domain
  type    = each.key

  alias {
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    name                   = aws_cloudfront_distribution.main.domain_name
    evaluate_target_health = false
  }
}
