resource "aws_security_group" "backend" {
  name_prefix = local.slug
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  description       = "SSH from everywhere"
}

resource "aws_vpc_security_group_egress_rule" "backend_vpc" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "all"
  cidr_ipv4         = "10.0.0.0/8"
  description       = "All to VPC"
}

resource "aws_security_group" "db" {
  name_prefix = local.slug
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "db_vpc" {
  security_group_id = aws_security_group.db.id
  ip_protocol       = "all"
  cidr_ipv4         = "10.0.0.0/8"
  description       = "All from VPC"
}
