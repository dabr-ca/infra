data "aws_iam_policy_document" "ro" {
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.self.arn,
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.self.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "ro" {
  name        = "S3BucketReadOnlyAccess-${aws_s3_bucket.self.id}"
  description = "Read-only access to S3 Bucket ${aws_s3_bucket.self.id}"
  policy      = data.aws_iam_policy_document.ro.json
}

data "aws_iam_policy_document" "rw" {
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.self.arn,
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "${aws_s3_bucket.self.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "rw" {
  name        = "S3BucketReadWriteAccess-${aws_s3_bucket.self.id}"
  description = "Read-write access to S3 Bucket ${aws_s3_bucket.self.id}"
  policy      = data.aws_iam_policy_document.rw.json
}
