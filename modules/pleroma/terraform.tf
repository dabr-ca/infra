terraform {
  required_version = ">= 1.2.9"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.9"
      configuration_aliases = [aws.us-east-1]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
