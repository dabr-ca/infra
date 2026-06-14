data "terraform_remote_state" "pleroma" {
  backend = "s3"

  config = {
    bucket = "tfstates-fdf62903"
    key    = "workspaces/pleroma/terraform.tfstate"
    region = "us-west-2"
  }
}

data "aws_instance" "pleroma" {
  instance_id = data.terraform_remote_state.pleroma.outputs.instance.id
}
