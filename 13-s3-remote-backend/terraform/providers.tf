terraform {
  required_version = ">= 1.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # This project uses LOCAL state intentionally!
  # It creates the S3 bucket that other projects use.
}

provider "aws" {
  region = var.aws_region
}
