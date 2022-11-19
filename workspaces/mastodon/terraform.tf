terraform {
  cloud {
    organization = "dabr-ca"
    workspaces {
      name = "mastodon"
    }
  }
}
