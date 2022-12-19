output "instance" {
  description = "The main EC2 instance."
  value = {
    arn        = aws_instance.main.arn
    public_ip  = aws_eip.main.public_ip
    private_ip = aws_instance.main.private_ip
  }
}

output "lb" {
  description = "The Application Load Balancer."
  value       = aws_lb.main
}

output "bucket_main" {
  description = "S3 bucket for storing user-uploaded files."
  value       = aws_s3_bucket.main
}

output "bucket_logs" {
  description = "S3 bucket for storing CloudFront and ELB logs."
  value       = aws_s3_bucket.logs
}
