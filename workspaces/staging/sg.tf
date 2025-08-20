resource "aws_security_group" "backend" {
  name_prefix = local.slug
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "backend_open" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "all"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "backend_open" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "all"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "db" {
  name_prefix = local.slug
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "db_vpc" {
  security_group_id = aws_security_group.db.id
  ip_protocol       = "all"
  cidr_ipv4         = "10.0.0.0/8"
}
