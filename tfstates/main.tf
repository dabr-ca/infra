module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.9.1"

  bucket = "tfstates-fdf62903"

  versioning = {
    enabled = true
  }
}

output "tfstates" {
  value = module.s3-bucket
}
