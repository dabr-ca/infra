resource "aws_s3_bucket" "logs" {
  bucket = "${var.name}-logs-${random_id.s3_bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "ExpireOldLogs"
    status = "Enabled"

    filter {}

    expiration {
      days = 365
    }
  }
}

# Allow CloudFront to deliver logs to the bucket
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html#AccessLogsBucketAndFileOwnership
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_log_delivery_canonical_user_id

data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_acl" "logs_cloudfront" {
  bucket = aws_s3_bucket.logs.id

  access_control_policy {
    grant {
      grantee {
        id   = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

# Allow ELB to deliver logs to the bucket
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account

resource "aws_s3_bucket_policy" "logs_elb" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs_bucket_policy.json
}

data "aws_elb_service_account" "elb" {}

data "aws_iam_policy_document" "logs_bucket_policy" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.elb.arn
      ]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.logs.arn}/*"
    ]
  }
}
