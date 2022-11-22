resource "aws_iam_role" "main" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role.json
}

data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "main" {
  name = aws_iam_role.main.name
  role = aws_iam_role.main.name
}

resource "aws_iam_role_policy" "main" {
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "main" {
  # Allow accessing S3 bucket
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*",
    ]
  }
  # Allow reading from parameter store
  # https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-access.html
  statement {
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:DeleteParameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:parameter/${local.name}/*"
    ]
  }
  statement {
    actions = [
      "ssm:DescribeParameters",
    ]
    resources = [
      "*"
    ]
  }
  # Allow sending emails
  # SednRawEmail is required by Swoosh
  # https://hexdocs.pm/swoosh/Swoosh.Adapters.AmazonSES.html
  statement {
    actions = [
      "ses:SendRawEmail"
    ]
    resources = ["*"]
  }
}

# XXX: I can't get IAM instance role to work with ExAws
# Use static access key for now
resource "aws_iam_user" "main" {
  name = local.name
}

resource "aws_iam_user_policy" "main" {
  user   = aws_iam_user.main.name
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_access_key" "main" {
  user = aws_iam_user.main.name
}

resource "aws_ssm_parameter" "aws_access_key_id" {
  name  = "/${local.name}/aws_access_key_id"
  type  = "String"
  value = aws_iam_access_key.main.id
}

resource "aws_ssm_parameter" "aws_secret_access_key" {
  name  = "/${local.name}/aws_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.main.secret
}
