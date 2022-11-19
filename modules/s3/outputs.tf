output "s3_bucket" {
  value = {
    name          = aws_s3_bucket.self.id
    arn           = aws_s3_bucket.self.arn
    domain        = aws_s3_bucket.self.bucket_regional_domain_name
    iam_policy_ro = aws_iam_policy.ro.arn
    iam_policy_rw = aws_iam_policy.rw.arn
  }
}
