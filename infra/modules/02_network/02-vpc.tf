# Creates a Virtual Private Cloud (VPC) named '<app_name>_vpc'.
# This VPC uses the IP address range 10.0.0.0/16
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Enable IPv6 support (optional but recommended for future-proofing)
  assign_generated_ipv6_cidr_block = true

  # enable_network_address_usage_metrics enables VPC Network Address Usage metrics.
  # For full VPC Flow Logs (to CloudWatch Logs or S3), configure an aws_flow_log resource.
  enable_network_address_usage_metrics = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

# gateway enables connectivity to internet from the VPC
resource "aws_internet_gateway" "app_vpc_gw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

# routing table associated with the Internet Gateway for the 'app_env' VPC
# Default Route and CIDR Specificity:
# - route with `cidr_block = "0.0.0.0/0"` is a catch-all rule that matches any IP address.
# - when multiple routes are available, the most specific CIDR block,
#   the longest subnet mask (largest prefix length), is selected.
#
# Example:
#   If there are two routes, one for `192.168.0.0/16` and another for `192.168.1.0/24`:
#   - A packet destined for `192.168.1.50` would match both routes.
#   - However, the route for `192.168.1.0/24` is selected because `/24` is more specific than `/16`.
resource "aws_route_table" "app_vpc_rt" {
  vpc_id = aws_vpc.app_vpc.id

  # IPv4 route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_vpc_gw.id
  }

  # IPv6 route
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.app_vpc_gw.id
  }

  tags = {
    Name = "${var.app_name}-route-table"
  }
}

# Outputs for the VPC and related resources
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
