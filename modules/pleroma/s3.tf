resource "random_id" "s3_bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.name}-${random_id.s3_bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls       = false # needed by Pleroma S3 uploader
  ignore_public_acls      = true  # ignore public ACL set by the Pleroma so that direct access is blocked
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  # Allow CloudFront to read from the bucket
  statement {
    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.main.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = aws_cloudfront_distribution.main.arn
    }
  }
}

resource "aws_ssm_parameter" "s3_bucket" {
  name  = "/${local.name}/s3_bucket"
  type  = "String"
  value = aws_s3_bucket.main.bucket
}

resource "aws_s3_object" "healthcheck" {
  bucket       = aws_s3_bucket.main.id
  key          = "healthcheck"
  content      = "OK"
  content_type = "text/plain"
}
