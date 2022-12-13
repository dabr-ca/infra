locals {
  # AWS: DBName must begin with a letter and contain only alphanumeric characters
  postgres_name     = "pleroma"
  postgres_username = "pleroma"
}

resource "aws_db_instance" "main" {
  engine                 = "postgres"
  engine_version         = "13.7" # default as of 2022-11
  parameter_group_name   = aws_db_parameter_group.main.name
  identifier             = local.name
  db_name                = local.postgres_name
  instance_class         = var.rds_instance_class
  storage_type           = "gp3"
  allocated_storage      = 20
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = 7

  username = local.postgres_username
  password = random_password.postgres.result
}

resource "aws_db_subnet_group" "main" {
  name       = local.name
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_parameter_group" "main" {
  name   = local.name
  family = "postgres13"
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
