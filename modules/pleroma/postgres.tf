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

# Tune PostgreSQL performance
# https://docs-develop.pleroma.social/backend/configuration/postgresql/
# https://pgtune.leopard.in.ua/
# DB Version: 13
# OS Type: linux
# DB Type: web
# Total Memory (RAM): 1 GB
# CPUs num: 2
# Connections num: 20
# Data Storage: ssd

# max_connections = 20
# shared_buffers = 256MB
# effective_cache_size = 768MB
# maintenance_work_mem = 64MB
# checkpoint_completion_target = 0.9
# wal_buffers = 7864kB
# default_statistics_target = 100
# random_page_cost = 1.1
# effective_io_concurrency = 200
# work_mem = 6553kB
# min_wal_size = 1GB
# max_wal_size = 4GB

resource "aws_db_parameter_group" "main" {
  name   = local.name
  family = "postgres13"

  # Sets the maximum number of concurrent connections.
  # Default: LEAST({DBInstanceClassMemory/9531392},5000) = 112
  parameter {
    max_connections = 20
  }
  # (8kB) Sets the number of shared memory buffers used by the server.
  # Default: {DBInstanceClassMemory/32768} = 32768
  parameter {
    shared_buffers = 32768
  }
  # (8kB) Sets the planners assumption about the size of the disk cache.
  # Default: {DBInstanceClassMemory/16384} = 65536
  parameter {
    effective_cache_size = 98304
  }
  # (kB) Sets the maximum memory to be used for maintenance operations.
  # Default: GREATEST({DBInstanceClassMemory*1024/63963136},65536) = 65536
  parameter {
    maintenance_work_mem = 65536
  }
  # Time spent flushing dirty buffers during checkpoint, as fraction of checkpoint interval.
  # Default: 0.9
  parameter {
    checkpoint_completion_target = 0.9
  }
  # (8kB) Sets the number of disk-page buffers in shared memory for WAL.
  # Default: (empty)
  parameter {
    wal_buffers = 983
  }
  # Sets the default statistics target.
  # Default: (empty)
  parameter {
    default_statistics_target = 100
  }
  # Sets the planners estimate of the cost of a nonsequentially fetched disk page.
  # Default: (empty)
  parameter {
    random_page_cost = 1.1
  }
  # Number of simultaneous requests that can be handled efficiently by the disk subsystem.
  # Default: (empty)
  parameter {
    effective_io_concurrency = 200
  }
  # (kB) Sets the maximum memory to be used for query workspaces.
  # Default: (empty)
  parameter {
    work_mem = 6553
  }
  # (MB) Sets the minimum size to shrink the WAL to.
  # Default: 192
  parameter {
    min_wal_size = 1024
  }
  # (MB) Sets the WAL size that triggers a checkpoint.
  # Default: 2048
  parameter {
    max_wal_size = 4096
  }
}
