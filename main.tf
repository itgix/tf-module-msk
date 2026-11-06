terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0" # Required by terraform-aws-modules/vpc/aws v6.1.0
    }
  }
}
