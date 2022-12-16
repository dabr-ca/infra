locals {
  domain = "dabr.ca"
}

module "pleroma" {
  source = "../../modules/pleroma"
  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  name               = "dabr-ca"
  domain             = local.domain
  files_domain       = "files.${local.domain}"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.subnet_ids.public[*]
  ec2_key_name       = "wzyboy@tarball"

  rds_instance_class = "db.m6g.large"
  rds_storage_type   = "gp3"
}

# Use Google Domain's MX
data "aws_route53_zone" "main" {
  name = local.domain
}

resource "aws_route53_record" "google_domains_mx" {
  zone_id = data.aws_route53_zone.main.id

  name = local.domain
  type = "MX"
  ttl  = 300
  records = [
    "5 gmr-smtp-in.l.google.com.",
    "10 alt1.gmr-smtp-in.l.google.com.",
    "20 alt2.gmr-smtp-in.l.google.com.",
    "30 alt3.gmr-smtp-in.l.google.com.",
    "40 alt4.gmr-smtp-in.l.google.com.",
  ]
}

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
