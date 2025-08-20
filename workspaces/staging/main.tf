locals {
  slug   = "staging"
  vpc_id = "vpc-0c272dc97fb9f589d"
}

resource "aws_instance" "main" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  subnet_id            = "subnet-0e726f617fb3c913f"
  key_name             = "wzyboy@tarball"
  iam_instance_profile = "dabr-ca"

  vpc_security_group_ids = [aws_security_group.backend.id]

  root_block_device {
    volume_type = "gp3"
    tags = {
      Name = "${local.slug}-root"
    }
  }

  tags = {
    Name = local.slug
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_db_instance" "main" {
  snapshot_identifier = "rds:dabr-ca-2025-08-20-11-41"

  identifier_prefix      = local.slug
  instance_class         = "db.m6g.large"
  storage_type           = "gp3"
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period      = 7
  performance_insights_enabled = false

  apply_immediately   = true
  deletion_protection = false
  skip_final_snapshot = true

  lifecycle {
    ignore_changes = [password]
  }
}

resource "aws_db_subnet_group" "main" {
  name_prefix = local.slug
  subnet_ids = [
    "subnet-0b3ac86d6125fb71e",
    "subnet-00c785138e18d8f2b",
    "subnet-0ed0d3f0375c30694"
  ]
}
