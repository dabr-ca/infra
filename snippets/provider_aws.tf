terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region. Default to us-west-2."
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
