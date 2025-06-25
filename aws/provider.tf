terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }
  backend "s3" {
    bucket         = "terraform-state-30564"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-db"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}


