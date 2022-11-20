module "mastodon" {
  source = "../../modules/mastodon"
  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  domain             = "dabr.ca"
  files_domain       = "files.dabr.ca"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.subnet_ids.public[*]
  ec2_key_name       = "wzyboy@tarball"
}
