output "sg_ids" {
  value = {
    default = aws_default_security_group.default.id
    ssh     = aws_security_group.ssh.id
    web     = aws_security_group.web.id
  }
}
