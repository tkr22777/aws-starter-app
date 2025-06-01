# =============================================================================
# Network Data Sources
# =============================================================================

# Lookup VPC using filter with environment-based naming
data "aws_vpc" "app_vpc" {
  count = var.vpc_id == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-vpc"]
  }
}

# Lookup main application subnet
data "aws_subnet" "main_subnet" {
  count = length(var.subnet_ids) == 0 ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-subnet-app"]
  }
}

# Lookup high availability subnet 2
data "aws_subnet" "subnet_ha_2" {
  count = length(var.subnet_ids) == 0 ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-subnet-ha-2"]
  }
}

# =============================================================================
# Local Values for Conditional References
# =============================================================================

locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : [
    data.aws_subnet.main_subnet[0].id,
    data.aws_subnet.subnet_ha_2[0].id
  ]
} 