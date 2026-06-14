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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
}
