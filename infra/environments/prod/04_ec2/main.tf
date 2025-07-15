terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "environments/prod/04_ec2/terraform.tfstate"
    region         = "us-east-1"      # Cannot use variables - processed during terraform init
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  profile = "terraform-user"
  region  = "us-east-1"

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.app_name
      Module      = "04_ec2"
      ManagedBy   = "terraform"
    }
  }
}

# Call the EC2 module
module "ec2" {
  source = "../../../modules/04_ec2"

  # Application Configuration
  app_name    = var.app_name
  environment = var.environment

  # Instance Configuration  
  instance_type              = var.instance_type
  root_volume_size          = var.root_volume_size
  root_volume_type          = var.root_volume_type
  root_volume_encrypted     = var.root_volume_encrypted
  enable_detailed_monitoring = var.enable_detailed_monitoring
  associate_public_ip       = var.associate_public_ip

  # Security Configuration
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  enable_ssh_access = var.enable_ssh_access

  # Network Configuration (from remote state)
  vpc_id    = local.vpc_id
  subnet_id = local.subnet_id
} 