terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_key
    region         = var.aws_region
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

