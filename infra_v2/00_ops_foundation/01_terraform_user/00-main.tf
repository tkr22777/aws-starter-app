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
    key            = "00_ops_foundation/01_terraform_user/terraform.tfstate"
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
      Project     = "ops" // Can be var.app_name if defined in this sub-module's vars
      ManagedBy   = "terraform"
    }
  }
}
