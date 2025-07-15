terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "environments/prod/04a_ec2_alb/terraform.tfstate"
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
      Module      = "04a_ec2_alb"
      ManagedBy   = "terraform"
    }
  }
}

# Call the EC2-ALB integration module
module "ec2_alb" {
  source = "../../../modules/04a_ec2_alb"

  # Application Configuration
  app_name    = var.app_name
  environment = var.environment

  # EC2 Integration (from EC2 module remote state)
  ec2_instance_id   = local.ec2_instance_id
  ec2_instance_port = var.ec2_instance_port

  # ALB Configuration
  api_path_prefix        = var.api_path_prefix
  listener_rule_priority = var.listener_rule_priority

  # Health Check Configuration
  health_check_enabled    = var.health_check_enabled
  health_check_path       = var.health_check_path
  health_check_interval   = var.health_check_interval
  health_check_timeout    = var.health_check_timeout
  healthy_threshold       = var.healthy_threshold
  unhealthy_threshold     = var.unhealthy_threshold

  # Network Configuration (from remote state)
  vpc_id = local.vpc_id

  # ALB Listener (will be discovered when ALB exists)
  alb_listener_arn = local.alb_listener_arn
} 