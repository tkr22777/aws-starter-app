# Creates a Virtual Private Cloud (VPC) named '<app_name>_vpc'.
# This VPC uses the IP address range 10.0.0.0/16
resource "aws_vpc" "turbo_test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  # Enable IPv6 support (optional but recommended for future-proofing)
  assign_generated_ipv6_cidr_block = true

  # Enable VPC flow logs for network monitoring (recommended for security)
  enable_network_address_usage_metrics = true

  tags = {
    name = "${var.app_name}_vpc"
  }
}

# gateway enables connectivity to internet from the VPC
resource "aws_internet_gateway" "turbo_test_vpc_gw" {
  vpc_id = aws_vpc.turbo_test_vpc.id
}

# routing table associated with the Internet Gateway for the 'test_env' VPC
# Default Route and CIDR Specificity:
# - route with `cidr_block = "0.0.0.0/0"` is a catch-all rule that matches any IP address.
# - when multiple routes are available, the most specific CIDR block,
#   the longest subnet mask (largest prefix length), is selected.
#
# Example:
#   If there are two routes, one for `192.168.0.0/16` and another for `192.168.1.0/24`:
#   - A packet destined for `192.168.1.50` would match both routes.
#   - However, the route for `192.168.1.0/24` is selected because `/24` is more specific than `/16`.
resource "aws_route_table" "turbo_test_vpc_rt" {
  vpc_id = aws_vpc.turbo_test_vpc.id
  
  # IPv4 route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.turbo_test_vpc_gw.id
  }
  
  # IPv6 route
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.turbo_test_vpc_gw.id
  }
}
