locals {
  name = var.name
}

resource "aws_instance" "main" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.ec2_instance_type
  subnet_id            = var.public_subnet_ids[0]
  key_name             = data.aws_key_pair.main.key_name
  iam_instance_profile = aws_iam_instance_profile.main.name

  vpc_security_group_ids = [aws_security_group.backend.id]

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

resource "aws_ebs_volume" "data" {
  availability_zone = aws_instance.main.availability_zone
  type              = "gp3"
  size              = 2

  tags = {
    Name = "${local.name}-data"
  }
}

resource "aws_volume_attachment" "data" {
  instance_id = aws_instance.main.id
  volume_id   = aws_ebs_volume.data.id
  device_name = "/dev/sdf"
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
}
