terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
  }

  required_version = ">= 1.2.0"
  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "01_cognito_user_pool/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  profile = "terraform_user"
  region  = "us-east-1"

  default_tags {
    tags = {
      Environment = "development"
      Project     = var.app_name
      ManagedBy   = "terraform"
    }
  }
}
