locals {
  name        = "mastodon"
  db_username = local.name
}

resource "aws_db_instance" "main" {
  engine                 = "postgres"
  engine_version         = "13.7" # default as of 2022-11
  parameter_group_name   = aws_db_parameter_group.main.name
  identifier             = local.name
  db_name                = local.name
  instance_class         = "db.t4g.micro"
  storage_type           = "gp2" # https://github.com/hashicorp/terraform-provider-aws/issues/27702
  allocated_storage      = 20
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_ids.default]

  username = local.db_username
  password = random_password.main.result
}

resource "aws_db_subnet_group" "main" {
  name       = local.name
  subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
}

resource "aws_db_parameter_group" "main" {
  name   = local.name
  family = "postgres13"
}

resource "random_password" "main" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/${local.name}/postgres/endpoint"
  type  = "String"
  value = aws_db_instance.main.endpoint
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${local.name}/postgres/username"
  type  = "String"
  value = local.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${local.name}/postgres/password"
  type  = "SecureString"
  value = random_password.main.result
}
