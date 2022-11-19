terraform {
  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "s3"
    }
  }
}
