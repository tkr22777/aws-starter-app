# All subnet definitions for the network module
# Main subnet for workloads + ALB subnet for load balancer multi-AZ requirement

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

# Minimal second subnet for ALB requirement (ALB needs 2 AZs)
resource "aws_subnet" "alb_subnet_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-alb-subnet-2"
  }
}

# enables resources within the subnet to follow the routing policies
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.app_vpc_sn.id
  route_table_id = aws_route_table.app_vpc_rt.id
}

# Route table association for ALB subnet
resource "aws_route_table_association" "alb_subnet_association" {
  subnet_id      = aws_subnet.alb_subnet_2.id
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

output "alb_subnet_2_id" {
  description = "The ID of the second ALB subnet"
  value       = aws_subnet.alb_subnet_2.id
}
