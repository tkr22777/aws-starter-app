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
  count = length(var.subnet_ids) == 0 ? 1 : 0
  
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc-subnet"]
  }
  
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_subnet" "subnet_ha_2" {
  count = length(var.subnet_ids) == 0 ? 1 : 0
  
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-subnet-2-ha"]
  }
  
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

# Locals to handle both explicit IDs and data source discovery
locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : [
    data.aws_subnet.app_subnet[0].id,
    data.aws_subnet.subnet_ha_2[0].id
  ]
}