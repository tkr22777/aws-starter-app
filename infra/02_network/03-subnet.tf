# All subnet definitions for the network module
# Main subnet for workloads + HA subnet for multi-AZ requirements (ALB, RDS, etc.)

resource "aws_subnet" "app_vpc_sn" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  
  # auto-assign public IP addresses for instances launched in this subnet
  map_public_ip_on_launch = true

  # IPv6 configuration
  ipv6_cidr_block = cidrsubnet(aws_vpc.app_vpc.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.app_name}-vpc-subnet"
  }
}

# Second subnet for high availability (HA) - automatically derived from main subnet config
resource "aws_subnet" "subnet_ha_2" {
  vpc_id            = aws_vpc.app_vpc.id
  # Auto-calculate CIDR: if main is 10.0.1.0/24, this becomes 10.0.3.0/24 (adds 2 to third octet)
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, tonumber(split(".", split("/", var.subnet_cidr_block)[0])[2]) + 2)
  # Auto-calculate AZ: if main is us-east-1a, this becomes us-east-1b
  availability_zone = "${substr(var.availability_zone, 0, length(var.availability_zone)-1)}${var.availability_zone == "${substr(var.availability_zone, 0, length(var.availability_zone)-1)}a" ? "b" : "a"}"
  
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-subnet-2-ha"
  }
}

# enables resources within the subnet to follow the routing policies
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.app_vpc_sn.id
  route_table_id = aws_route_table.app_vpc_rt.id
}

# Route table association for ALB subnet
resource "aws_route_table_association" "subnet_ha_2_association" {
  subnet_id      = aws_subnet.subnet_ha_2.id
  route_table_id = aws_route_table.app_vpc_rt.id
}

# Outputs for the subnet and related resources
output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.app_vpc_sn.id
}

output "subnet_cidr" {
  description = "The CIDR block of the subnet"
  value       = aws_subnet.app_vpc_sn.cidr_block
}

output "subnet_availability_zone" {
  description = "The availability zone of the subnet"
  value       = aws_subnet.app_vpc_sn.availability_zone
}

output "subnet_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the subnet"
  value       = aws_subnet.app_vpc_sn.ipv6_cidr_block
}

# HA subnet outputs
output "subnet_ha_2_id" {
  description = "The ID of the second high-availability subnet"
  value       = aws_subnet.subnet_ha_2.id
}

output "subnet_ha_2_cidr" {
  description = "The CIDR block of the HA subnet (auto-calculated)"
  value       = aws_subnet.subnet_ha_2.cidr_block
}

output "subnet_ha_2_availability_zone" {
  description = "The availability zone of the HA subnet (auto-calculated)"
  value       = aws_subnet.subnet_ha_2.availability_zone
}
