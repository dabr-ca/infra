# Backend
resource "aws_security_group" "backend" {
  name   = local.name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "backend_ingress_ssh" {
  security_group_id = aws_security_group.backend.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "backend_ingress_mosh" {
  security_group_id = aws_security_group.backend.id
  type              = "ingress"
  protocol          = "udp"
  from_port         = 60000
  to_port           = 61000
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "backend_ingress_lb" {
  security_group_id        = aws_security_group.backend.id
  type                     = "ingress"
  protocol                 = "all"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "backend_egress_all" {
  security_group_id = aws_security_group.backend.id
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# Load balancer
resource "aws_security_group" "lb" {
  name   = "${local.name}-lb"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "lb_ingress_http" {
  security_group_id = aws_security_group.lb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_ingress_https" {
  security_group_id = aws_security_group.lb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_egress_all" {
  security_group_id = aws_security_group.lb.id
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# Database
resource "aws_security_group" "db" {
  name   = "${local.name}-db"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "db_ingress_backend" {
  security_group_id        = aws_security_group.db.id
  type                     = "ingress"
  protocol                 = "all"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.backend.id
}
