terraform {
  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "database"
    }
  }
}
