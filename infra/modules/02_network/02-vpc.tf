# Creates a Virtual Private Cloud (VPC) named '<app_name>_vpc'.
# This VPC uses the IP address range 10.0.0.0/16
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr_block # Private IP range - 10.0.0.0/16 provides 65,534 usable addresses
  enable_dns_hostnames = true # Allows instances to have public DNS hostnames
  enable_dns_support   = true # Enables DNS resolution within the VPC

  # Enable IPv6 support (optional but recommended for future-proofing)
  assign_generated_ipv6_cidr_block = true # AWS assigns a /56 IPv6 block (281 trillion addresses)

  # enable_network_address_usage_metrics enables VPC Network Address Usage metrics.
  # For full VPC Flow Logs (to CloudWatch Logs or S3), configure an aws_flow_log resource.
  enable_network_address_usage_metrics = true # Tracks IP address utilization for monitoring

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

# gateway enables connectivity to internet from the VPC
resource "aws_internet_gateway" "app_vpc_gw" {
  vpc_id = aws_vpc.app_vpc.id # Attaches to VPC - required for public internet access

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
    cidr_block = "0.0.0.0/0" # Default route - matches all IPv4 traffic not handled by more specific routes
    gateway_id = aws_internet_gateway.app_vpc_gw.id
  }

  # IPv6 route
  route {
    ipv6_cidr_block = "::/0" # Default route for IPv6 - equivalent to 0.0.0.0/0 for IPv4
    gateway_id      = aws_internet_gateway.app_vpc_gw.id
  }

  tags = {
    Name = "${var.app_name}-route-table"
  }
}
