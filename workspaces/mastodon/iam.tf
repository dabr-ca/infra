resource "aws_iam_role" "main" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role.json
}

resource "aws_iam_instance_profile" "main" {
  name = aws_iam_role.main.name
  role = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.main.name
  policy_arn = data.terraform_remote_state.s3.outputs.s3-main.iam_policy_rw
}

resource "aws_iam_role_policy" "main" {
  role   = aws_iam_role.main.name
  policy = data.terraform_remote_state.s3.outputs.s3-main.iam_policy_rw
}

data "aws_iam_policy_document" "main" {
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
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = [
      "*"
    ]
  }
}
