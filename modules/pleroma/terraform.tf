terraform {
  required_version = ">= 1.2.9"
  required_providers {
    # gp3 requires > 4.45
    # https://github.com/hashicorp/terraform-provider-aws/issues/27702
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.45"
      configuration_aliases = [aws.us-east-1]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
