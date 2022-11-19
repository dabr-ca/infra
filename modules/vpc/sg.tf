# Default security group that allows ingress VPC traffic and egress world
# traffic. It is suitable for almost all situations.
resource "aws_default_security_group" "default" {
  vpc_id = one(aws_vpc.this).id

  tags = {
    Name = "${var.name}-default-sg"
  }

  ingress {
    description = "Allow all traffic from VPC"
    protocol    = "all"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [one(aws_vpc.this).cidr_block]
  }

  ingress {
    description = "Allow ICMP traffic from anywhere"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffic to anywehere"
    protocol    = "all"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group that allows remote access to Linux instances.
resource "aws_security_group" "ssh" {
  name   = "ssh"
  vpc_id = one(aws_vpc.this).id

  ingress {
    description = "OpenSSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Mosh"
    protocol    = "udp"
    from_port   = 60000
    to_port     = 61000
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group that allows HTTP(S) traffic.
resource "aws_security_group" "web" {
  name   = "web"
  vpc_id = one(aws_vpc.this).id

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}
