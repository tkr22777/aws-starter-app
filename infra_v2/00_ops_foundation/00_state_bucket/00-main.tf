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
    key            = "00_ops_foundation/00_state_bucket/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  profile = "root"
  region = "us-east-1"
  
  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Environment = "foundation"
    }
  }
}
