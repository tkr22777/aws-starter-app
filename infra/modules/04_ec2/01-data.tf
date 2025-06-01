# Conditional data sources - only used if explicit IDs not provided
data "aws_vpc" "app_vpc" {
  count = var.vpc_id == "" ? 1 : 0
  
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc"]
  }
  
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_subnet" "app_subnet" {
  count = var.subnet_id == "" ? 1 : 0
  
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc-subnet"]
  }
  
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

# Get ECS-optimized Amazon Linux 2023 AMI (has Docker pre-installed)
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Locals to handle both explicit IDs and data source discovery
locals {
  vpc_id    = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
  subnet_id = var.subnet_id != "" ? var.subnet_id : data.aws_subnet.app_subnet[0].id
} 