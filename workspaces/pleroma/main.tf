locals {
  domain = "dabr.ca"
}

module "pleroma" {
  source = "../../modules/pleroma"
  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  domain             = local.domain
  files_domain       = "files.${local.domain}"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.subnet_ids.public[*]
  ec2_key_name       = "wzyboy@tarball"
}

moved {
  from = module.mastodon
  to   = module.pleroma
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
