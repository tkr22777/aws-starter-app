terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10" # Match module version
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "terraform-state-store-24680" # Replace with your actual bucket name
    key            = "environments/prod/03_rds/terraform.tfstate"
    region         = "us-east-1"      # Cannot use variables - processed during terraform init
    dynamodb_table = "terraform-state-locks" # Replace with your actual DynamoDB table name
  }
}

provider "aws" {
  profile = "terraform-user" # Ensure this profile is configured
  region  = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.app_name
      ManagedBy   = "terraform"
      Module      = "03_rds"
    }
  }
}

module "rds" {
  source = "../../../modules/03_rds"

  app_name    = var.app_name
  environment = var.environment
  db_password = var.db_password
  vpc_id      = local.vpc_id      # From remote state
  subnet_ids  = local.subnet_ids  # From remote state
}