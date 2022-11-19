resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "self" {
  bucket = "${var.slug}-${random_id.bucket.hex}"

  lifecycle {
    ignore_changes = [
      policy,
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "self" {
  bucket = aws_s3_bucket.self.id

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = !var.public
  restrict_public_buckets = !var.public
}

data "aws_iam_policy_document" "public_read" {
  count = var.public ? 1 : 0

  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.self.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  count = var.public ? 1 : 0

  bucket = aws_s3_bucket.self.id
  policy = data.aws_iam_policy_document.public_read[0].json
}
