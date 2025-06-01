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
    key            = "environments/prod/02_network/terraform.tfstate"
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
      Module      = "02_network"
    }
  }
}

module "network" {
  source = "../../../modules/02_network"

  app_name                        = var.app_name
  environment                     = var.environment
  vpc_cidr_block                  = var.vpc_cidr_block
  subnet_cidr_block               = var.subnet_cidr_block
  availability_zone               = var.availability_zone
  subnet_ha_2_cidr_block          = var.subnet_ha_2_cidr_block
  subnet_ha_2_availability_zone   = var.subnet_ha_2_availability_zone
} 