locals {
  # AWS: DBName must begin with a letter and contain only alphanumeric characters
  postgres_name     = "pleroma"
  postgres_username = "pleroma"
}

resource "aws_db_instance" "main" {
  engine                 = "postgres"
  engine_version         = "15.13"
  identifier             = local.name
  db_name                = local.postgres_name
  instance_class         = var.rds_instance_class
  storage_type           = var.rds_storage_type
  allocated_storage      = var.rds_allocated_storage
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period      = 7
  performance_insights_enabled = true

  apply_immediately   = true
  deletion_protection = true

  username = local.postgres_username
  password = random_password.postgres.result

  lifecycle {
    # FIXME
    ignore_changes = [engine_version, allocated_storage]
  }
}

locals {
  # Indirectly referencing via a local variable avoids force reading of data
  # source.
  db_az = aws_db_instance.main.availability_zone
}

resource "aws_db_subnet_group" "main" {
  name       = local.name
  subnet_ids = var.private_subnet_ids
}

resource "random_password" "postgres" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "postgres_address" {
  name  = "/${local.name}/postgres/address"
  type  = "String"
  value = aws_db_instance.main.address
}

resource "aws_ssm_parameter" "postgres_name" {
  name  = "/${local.name}/postgres/name"
  type  = "String"
  value = local.postgres_name
}

resource "aws_ssm_parameter" "postgres_username" {
  name  = "/${local.name}/postgres/username"
  type  = "String"
  value = local.postgres_username
}

resource "aws_ssm_parameter" "postgres_password" {
  name  = "/${local.name}/postgres/password"
  type  = "SecureString"
  value = random_password.postgres.result
}

resource "aws_ssm_parameter" "postgres_heartbeat_url" {
  name  = "/${local.name}/postgres/heartbeat_url"
  type  = "String"
  value = "." # populate this value manually

  lifecycle {
    ignore_changes = [value]
  }
}
