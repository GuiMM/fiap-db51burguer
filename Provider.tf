terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
