terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
  }
  required_version = "1.15.8"
}

provider "aws" {
  profile = "maw9-master"
  region  = var.vpc-region
}