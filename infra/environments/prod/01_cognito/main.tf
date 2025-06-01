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
    key            = "environments/prod/01_cognito/terraform.tfstate"
    region         = "us-east-1"      # Replace with your desired region
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
      Module      = "01_cognito"
    }
  }
}

module "cognito" {
  source = "../../../modules/01_cognito"

  app_name          = var.app_name
  app_callback_urls = var.app_callback_urls
  app_logout_urls   = var.app_logout_urls
  # Add other variables from the module as needed
} 