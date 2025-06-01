terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "cloudtrail/terraform.tfstate"
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
      Module      = "cloudtrail"
    }
  }
}

locals {
  cloudtrail_name             = var.cloudtrail_name != null ? var.cloudtrail_name : "${var.app_name}-cloudtrail"
  s3_bucket_name              = var.s3_bucket_name != null ? var.s3_bucket_name : "${var.app_name}-cloudtrail-logs-${random_id.bucket_suffix.hex}"
  cloudwatch_log_group_name   = "/aws/cloudtrail/${local.cloudtrail_name}"
  
  common_tags = merge(var.tags, {
    Name        = local.cloudtrail_name
    Description = "CloudTrail for ${var.app_name} audit logging"
  })
} 