# =============================================================================
# VPC Outputs
# =============================================================================

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.app_vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.app_vpc.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.app_vpc.ipv6_cidr_block
}

output "vpc_default_security_group_id" {
  description = "The ID of the default security group created with the VPC"
  value       = aws_vpc.app_vpc.default_security_group_id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.app_vpc_gw.id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.app_vpc_rt.id
}

# =============================================================================
# Subnet Outputs
# =============================================================================

output "subnet_id" {
  description = "The ID of the primary subnet"
  value       = aws_subnet.app_vpc_sn.id
}

output "subnet_cidr" {
  description = "The CIDR block of the primary subnet"
  value       = aws_subnet.app_vpc_sn.cidr_block
}

output "subnet_availability_zone" {
  description = "The availability zone of the primary subnet"
  value       = aws_subnet.app_vpc_sn.availability_zone
}

output "subnet_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the primary subnet"
  value       = aws_subnet.app_vpc_sn.ipv6_cidr_block
}

# =============================================================================
# HA Subnet Outputs
# =============================================================================

output "subnet_ha_2_id" {
  description = "The ID of the second high-availability subnet"
  value       = aws_subnet.subnet_ha_2.id
}

output "subnet_ha_2_cidr" {
  description = "The CIDR block of the HA subnet"
  value       = aws_subnet.subnet_ha_2.cidr_block
}

output "subnet_ha_2_availability_zone" {
  description = "The availability zone of the HA subnet"
  value       = aws_subnet.subnet_ha_2.availability_zone
}

# =============================================================================
# CLI Examples
# =============================================================================

# Example AWS CLI commands for verification:
# aws ec2 describe-vpcs --vpc-ids <vpc_id>
# aws ec2 describe-subnets --subnet-ids <subnet_id> <subnet_ha_2_id>
# aws ec2 describe-internet-gateways --internet-gateway-ids <internet_gateway_id> 