locals {
  name = "dabr-ca-temp-ubuntu"
}

resource "aws_instance" "temp_ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = data.aws_instance.pleroma.instance_type
  subnet_id              = data.aws_instance.pleroma.subnet_id
  key_name               = data.aws_instance.pleroma.key_name
  iam_instance_profile   = data.aws_instance.pleroma.iam_instance_profile
  vpc_security_group_ids = data.aws_instance.pleroma.vpc_security_group_ids

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    tags = {
      Name = "${local.name}-root"
    }
  }

  tags = {
    Name = local.name
  }
}

output "instance" {
  description = "The temporary Ubuntu EC2 instance."
  value = {
    id         = aws_instance.temp_ubuntu.id
    ami        = aws_instance.temp_ubuntu.ami
    type       = aws_instance.temp_ubuntu.instance_type
    public_ip  = aws_instance.temp_ubuntu.public_ip
    private_ip = aws_instance.temp_ubuntu.private_ip
  }
}
