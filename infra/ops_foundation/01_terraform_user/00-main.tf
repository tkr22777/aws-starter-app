terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
  
  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "ops_foundation/01_terraform_user/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  profile = "root"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "foundation-iam"
      Project     = var.app_name
      ManagedBy   = "terraform"
    }
  }
}
