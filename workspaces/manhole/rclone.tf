# Offsite (non-AWS environment) backup of Pleroma media

variable "main_bucket_name" {
  type        = string
  description = "Name of the main bucket as rclone source, extracted from the output of pleroma module."
}

data "aws_s3_bucket" "main" {
  bucket = var.main_bucket_name
}

data "aws_iam_policy_document" "rclone" {
  statement {
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [data.aws_s3_bucket.main.arn]
  }
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = ["${data.aws_s3_bucket.main.arn}/*"]
  }
}

resource "aws_iam_user" "rclone" {
  name = "rclone-${data.aws_s3_bucket.main.bucket}"
}

resource "aws_iam_user_policy" "rclone" {
  user   = aws_iam_user.rclone.name
  policy = data.aws_iam_policy_document.rclone.json
}

resource "aws_iam_access_key" "rclone" {
  user = aws_iam_user.rclone.name
}

output "rclone_access_key_id" {
  value = aws_iam_access_key.rclone.id
}

output "rclone_secret_access_key" {
  value     = aws_iam_access_key.rclone.secret
  sensitive = true
}
