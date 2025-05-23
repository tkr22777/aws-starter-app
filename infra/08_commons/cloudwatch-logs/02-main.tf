terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "cloudwatch-logs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = var.app_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "cloudwatch-logs"
    }
  }
}

locals {
  log_group_prefix = "/aws/${var.app_name}"
  
  common_tags = merge(var.tags, {
    Description = "CloudWatch Logs for ${var.app_name} application logging"
  })
} 