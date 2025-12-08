locals {
  name = "dabr-ca"
}

data "aws_instance" "main" {
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_instance" "manhole" {
  ami                    = data.aws_ami.ubuntu22.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_instance.main.subnet_id
  key_name               = data.aws_instance.main.key_name
  iam_instance_profile   = data.aws_instance.main.iam_instance_profile
  vpc_security_group_ids = data.aws_instance.main.vpc_security_group_ids

  # Run pg_dump on instance startup
  user_data_base64            = data.cloudinit_config.manhole.rendered
  user_data_replace_on_change = true

  # Shutdown to terminate the instance
  #instance_initiated_shutdown_behavior = "terminate"

  root_block_device {
    volume_type = "gp3"
    volume_size = 32
  }

  tags = {
    Name = "manhole"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

data "cloudinit_config" "manhole" {
  part {
    filename     = "pg_dump.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/pg_dump.sh")
  }
}

output "ec2_public_addr" {
  value = aws_instance.manhole.public_ip
}
