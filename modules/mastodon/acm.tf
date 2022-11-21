resource "aws_acm_certificate" "main" {
  domain_name       = data.aws_route53_zone.main.name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${data.aws_route53_zone.main.name}",
  ]
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

# CloudFront requires ACM to be in us-east-1, so duplicate the resources.
resource "aws_acm_certificate" "us-east-1" {
  provider = aws.us-east-1

  domain_name       = data.aws_route53_zone.main.name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${data.aws_route53_zone.main.name}",
  ]
}

resource "aws_acm_certificate_validation" "us-east-1" {
  provider = aws.us-east-1

  certificate_arn         = aws_acm_certificate.us-east-1.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
}
