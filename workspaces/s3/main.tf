module "s3-main" {
  source = "../../modules/s3"

  slug   = "dabr-ca"
  public = false
}
