resource "aws_elasticache_cluster" "main" {
  engine               = "redis"
  cluster_id           = local.name
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  engine_version       = "7.0" # default as of 2022-11
  parameter_group_name = aws_elasticache_parameter_group.main.name
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [data.terraform_remote_state.vpc.outputs.sg_ids.default]
}

resource "aws_elasticache_subnet_group" "main" {
  name       = local.name
  subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids.private[*]
}

resource "aws_elasticache_parameter_group" "main" {
  name   = local.name
  family = "redis7"
}

resource "aws_ssm_parameter" "redis_endpoint" {
  name  = "/${local.name}/redis/address"
  type  = "String"
  value = one(aws_elasticache_cluster.main.cache_nodes)["address"]
}
