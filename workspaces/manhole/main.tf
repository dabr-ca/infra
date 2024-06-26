locals {
  name   = "dabr-ca"
  domain = "dabr.ca"
}

data "aws_instance" "main" {
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_instance" "manhole" {
  ami                    = data.aws_ami.ubuntu22.id
  instance_type          = data.aws_instance.main.instance_type
  subnet_id              = data.aws_instance.main.subnet_id
  key_name               = data.aws_instance.main.key_name
  iam_instance_profile   = data.aws_instance.main.iam_instance_profile
  vpc_security_group_ids = data.aws_instance.main.vpc_security_group_ids

  root_block_device {
    volume_type = "gp3"
  }

  tags = {
    Name = "manhole"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
