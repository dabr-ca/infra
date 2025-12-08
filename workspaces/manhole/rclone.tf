# Offsite (non-AWS environment) backup of Pleroma media

variable "bucket_suffix" {
  type        = string
  description = "Bucket suffix, extracted from the output of pleroma module."
}

data "aws_s3_bucket" "rclone" {
  for_each = toset(["dabr-ca-${var.bucket_suffix}", "dabr-ca-backup-${var.bucket_suffix}"])
  bucket   = each.key
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
    resources = [for k in data.aws_s3_bucket.rclone : k.arn]
  }
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [for k in data.aws_s3_bucket.rclone : "${k.arn}/*"]
  }
}

resource "aws_iam_user" "rclone" {
  name = "rclone-${var.bucket_suffix}"
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
