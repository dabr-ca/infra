module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.4.0"

  function_name = "pg_dump"
  runtime       = "python3.11"
  handler       = "main.lambda_handler"
  timeout       = 60

  source_path = "./src"

  environment_variables = {
    TAG_NAME = "dabr-ca"
  }

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.ec2_run_instances.json

  cloudwatch_logs_retention_in_days = 365
}


data "aws_iam_policy_document" "ec2_run_instances" {
  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:DescribeInstances",
    ]
    resources = ["*"]
  }
}
