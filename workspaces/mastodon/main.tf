locals {
  name = "mastodon"
}

resource "aws_instance" "main" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  subnet_id            = data.terraform_remote_state.vpc.outputs.subnet_ids.public[0]
  key_name             = data.aws_key_pair.main.key_name
  iam_instance_profile = aws_iam_instance_profile.main.name

  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.sg_ids.default,
    data.terraform_remote_state.vpc.outputs.sg_ids.ssh,
    data.terraform_remote_state.vpc.outputs.sg_ids.web,
  ]

  root_block_device {
    volume_type = "gp3"
    tags = {
      Name = "${local.name}-root"
    }
  }

  tags = {
    Name = local.name
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
}
