output "instance" {
  value = {
    arn        = aws_instance.main.arn
    public_ip  = aws_eip.main.public_ip
    private_ip = aws_instance.main.private_ip
  }
}
