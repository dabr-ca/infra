locals {
  pg_dump_prefix = "pgdump/"
}

resource "aws_s3_bucket" "backup" {
  bucket = "${var.name}-backup-${random_id.s3_bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "ArchiveDatabaseDumps"
    status = "Enabled"

    filter {
      prefix = local.pg_dump_prefix
    }

    transition {
      days          = 7
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "DeleteDatabaseDumps"
    status = "Enabled"

    filter {
      prefix = local.pg_dump_prefix
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_ssm_parameter" "s3_bucket_backup" {
  name  = "/${local.name}/s3_bucket_backup"
  type  = "String"
  value = aws_s3_bucket.backup.bucket
}
