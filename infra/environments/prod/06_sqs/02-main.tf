terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "environments/prod/06_sqs/terraform.tfstate"
    region         = "us-east-1"      # Cannot use variables - processed during terraform init
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.app_name
      Module      = "06_sqs"
      ManagedBy   = "terraform"
    }
  }
} 