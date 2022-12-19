# Set up a static IAM user so that Logstash can read logs from a non-AWS environment

resource "aws_iam_user" "logstash" {
  name = "logstash"
}

resource "aws_iam_user_policy" "logstash" {
  user   = aws_iam_user.logstash.name
  policy = data.aws_iam_policy_document.logstash.json
}

resource "aws_iam_access_key" "logstash" {
  user = aws_iam_user.logstash.name
}

data "aws_iam_policy_document" "logstash" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [module.pleroma.bucket_logs.arn]
  }
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.pleroma.bucket_logs.arn}/*"]
  }
}

output "logstash" {
  description = "Information for setting up Logstash."
  value = {
    bucket            = module.pleroma.bucket_logs.id
    access_key_id     = aws_iam_access_key.logstash.id
    secret_access_key = aws_iam_access_key.logstash.secret
  }
  sensitive = true
}
