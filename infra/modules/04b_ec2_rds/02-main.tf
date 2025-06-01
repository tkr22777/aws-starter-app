terraform {
  required_version = "~> 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      Environment = "prod"
      Project     = var.app_name
      Module      = "04b_ec2_rds"
      ManagedBy   = "terraform"
    }
  }
} 