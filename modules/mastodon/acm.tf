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
