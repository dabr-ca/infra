# Backend
resource "aws_security_group" "backend" {
  name   = local.name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  description       = "SSH"
}

resource "aws_vpc_security_group_ingress_rule" "backend_mosh" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "udp"
  from_port         = 60000
  to_port           = 61000
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Mosh"
}

resource "aws_vpc_security_group_ingress_rule" "backend_lb" {
  security_group_id            = aws_security_group.backend.id
  ip_protocol                  = "all"
  referenced_security_group_id = aws_security_group.lb.id
}

resource "aws_vpc_security_group_egress_rule" "backend_all" {
  security_group_id = aws_security_group.backend.id
  ip_protocol       = "all"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All"
}

# Load balancer
resource "aws_security_group" "lb" {
  name   = "${local.name}-lb"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "lb_icmp" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
  description       = "ICMP"
}

resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "lb_https" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTPS"
}

resource "aws_vpc_security_group_egress_rule" "lb_all" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "all"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All"
}

# Database
resource "aws_security_group" "db" {
  name   = "${local.name}-db"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "db_backend" {
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "all"
  referenced_security_group_id = aws_security_group.backend.id
  description                  = "All"
}
