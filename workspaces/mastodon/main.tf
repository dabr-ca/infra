locals {
  name = "mastodon"
}

module "mastodon" {
  source = "../../modules/mastodon"

  domain             = "dabr.ca"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.subnet_ids.public[*]
  ec2_key_name       = "wzyboy@tarball"
}
