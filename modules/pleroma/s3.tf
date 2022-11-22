resource "random_id" "s3_bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.name}-${random_id.s3_bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_cloudfront_origin_access_identity" "main" {}

data "aws_iam_policy_document" "bucket_policy" {
  # Allow CloudFront to read from the bucket
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.main.arn}/*",
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.main.iam_arn
      ]
    }
  }
}

resource "aws_ssm_parameter" "s3_bucket" {
  name  = "/${local.name}/s3_bucket"
  type  = "String"
  value = aws_s3_bucket.main.bucket
}