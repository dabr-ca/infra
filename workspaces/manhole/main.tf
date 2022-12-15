locals {
  name = "dabr-ca"
}

data "aws_instance" "main" {
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "aws_instance" "manhole" {
  ami                    = data.aws_instance.main.ami
  instance_type          = data.aws_instance.main.instance_type
  subnet_id              = data.aws_instance.main.subnet_id
  key_name               = data.aws_instance.main.key_name
  iam_instance_profile   = data.aws_instance.main.iam_instance_profile
  vpc_security_group_ids = data.aws_instance.main.vpc_security_group_ids

  root_block_device {
    volume_type = "gp3"
  }
}

resource "aws_eip" "manhole" {
  instance = aws_instance.manhole.id
}

output "manhole_address" {
  value = aws_eip.manhole.public_ip
}
