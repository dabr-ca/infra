resource "aws_cloudfront_distribution" "main" {
  aliases          = [var.files_domain]
  enabled          = true
  is_ipv6_enabled  = true
  price_class      = "PriceClass_All"
  retain_on_delete = true

  default_cache_behavior {
    target_origin_id = aws_s3_bucket.main.bucket_regional_domain_name

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
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
