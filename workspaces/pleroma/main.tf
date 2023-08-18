locals {
  name   = "dabr-ca"
  domain = "dabr.ca"
}

module "pleroma" {
  source = "../../modules/pleroma"
  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  name               = local.name
  domain             = local.domain
  files_domain       = "files.${local.domain}"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.subnet_ids.public[*]
  ec2_key_name       = "wzyboy@tarball"

  rds_instance_class    = "db.m6g.large"
  rds_storage_type      = "gp3"
  rds_allocated_storage = 25

  domain_spf_record = "v=spf1 include:amazonses.com include:spf.messagingengine.com -all"
}
