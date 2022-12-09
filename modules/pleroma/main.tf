locals {
  name = var.name
}

# Place EC2 in the same AZ as the RDS to avoid cross-AZ data charge
data "aws_subnet" "ec2" {
  for_each = toset(var.public_subnet_ids)

  id = each.key
  filter {
    name   = "availability-zone"
    values = [aws_db_instance.main.availability_zone]
  }
}

resource "aws_instance" "main" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.ec2_instance_type
  subnet_id            = one(data.aws_subnet.ec2[*].id)
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

resource "aws_eip" "main" {
  instance = aws_instance.main.id
}
