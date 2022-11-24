resource "aws_cloudfront_distribution" "main" {
  aliases             = [var.files_domain]
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = true
  wait_for_deployment = false

  default_cache_behavior {
    target_origin_id = aws_s3_bucket.main.bucket_regional_domain_name

    compress                 = true
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = data.aws_cloudfront_cache_policy.managed["CachingOptimized"].id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed["CORS-S3Origin"].id
  }

  ordered_cache_behavior {
    path_pattern     = "proxy/*"
    target_origin_id = aws_lb.main.dns_name

    compress                 = true
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = data.aws_cloudfront_cache_policy.managed["CachingOptimized"].id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed["CORS-S3Origin"].id
  }

  origin {
    origin_id   = aws_s3_bucket.main.bucket_regional_domain_name
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  origin {
    origin_id   = aws_lb.main.dns_name
    domain_name = data.aws_route53_zone.main.name

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.us-east-1.certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  logging_config {
    bucket = aws_s3_bucket.logs.bucket_regional_domain_name
    prefix = "cloudfront/"
  }
}

resource "aws_route53_record" "files" {
  for_each = toset(["A", "AAAA"])

  zone_id = data.aws_route53_zone.main.id
  name    = var.files_domain
  type    = each.key

  alias {
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    name                   = aws_cloudfront_distribution.main.domain_name
    evaluate_target_health = false
  }
}

# Managed policies
locals {
  managed_cache_policies = [
    "Amplify",
    "CachingDisabled",
    "CachingOptimized",
    "CachingOptimizedForUncompressedObjects",
    "Elemental-MediaPackage",
  ]
  managed_origin_request_policies = [
    "AllViewer",
    "CORS-CustomOrigin",
    "CORS-S3Origin",
    "Elemental-MediaTailor-PersonalizedManifests",
    "UserAgentRefererHeaders",
  ]
}

data "aws_cloudfront_cache_policy" "managed" {
  for_each = toset(local.managed_cache_policies)

  name = "Managed-${each.key}"
}

data "aws_cloudfront_origin_request_policy" "managed" {
  for_each = toset(local.managed_origin_request_policies)

  name = "Managed-${each.key}"
}
