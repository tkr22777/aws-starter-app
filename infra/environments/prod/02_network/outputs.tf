# =============================================================================
# VPC Outputs
# =============================================================================

output "vpc_id" {
  description = "The ID of the production VPC."
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the production VPC."
  value       = module.network.vpc_cidr
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the production VPC."
  value       = module.network.vpc_ipv6_cidr_block
}

output "vpc_default_security_group_id" {
  description = "The ID of the default security group created with the production VPC."
  value       = module.network.vpc_default_security_group_id
}

output "internet_gateway_id" {
  description = "The ID of the production Internet Gateway."
  value       = module.network.internet_gateway_id
}

output "route_table_id" {
  description = "The ID of the production route table."
  value       = module.network.route_table_id
}

# =============================================================================
# Subnet Outputs
# =============================================================================

output "subnet_id" {
  description = "The ID of the primary production subnet."
  value       = module.network.subnet_id
}

output "subnet_cidr" {
  description = "The CIDR block of the primary production subnet."
  value       = module.network.subnet_cidr
}

output "subnet_availability_zone" {
  description = "The availability zone of the primary production subnet."
  value       = module.network.subnet_availability_zone
}

output "subnet_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the primary production subnet."
  value       = module.network.subnet_ipv6_cidr_block
}

# =============================================================================
# HA Subnet Outputs
# =============================================================================

output "subnet_ha_2_id" {
  description = "The ID of the second high-availability production subnet."
  value       = module.network.subnet_ha_2_id
}

output "subnet_ha_2_cidr" {
  description = "The CIDR block of the HA production subnet."
  value       = module.network.subnet_ha_2_cidr
}

output "subnet_ha_2_availability_zone" {
  description = "The availability zone of the HA production subnet."
  value       = module.network.subnet_ha_2_availability_zone
}

# =============================================================================
# Usage Examples
# =============================================================================

# Example AWS CLI commands for production network verification:
# aws ec2 describe-vpcs --vpc-ids $(terraform output -raw vpc_id)
# aws ec2 describe-subnets --subnet-ids $(terraform output -raw subnet_id) $(terraform output -raw subnet_ha_2_id)
# aws ec2 describe-internet-gateways --internet-gateway-ids $(terraform output -raw internet_gateway_id) 