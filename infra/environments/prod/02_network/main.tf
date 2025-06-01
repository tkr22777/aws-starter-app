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
    key            = "environments/prod/02_network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.app_name
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source = "../../../modules/02_network"

  app_name          = var.app_name
  environment       = var.environment
  vpc_cidr_block    = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
} 