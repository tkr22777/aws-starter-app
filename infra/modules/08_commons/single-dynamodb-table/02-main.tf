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
    key            = "08_commons/mono-ddb-table/terraform.tfstate"
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