# All subnet definitions for the network module
# Main subnet for workloads + HA subnet for multi-AZ requirements (ALB, RDS, etc.)

resource "aws_subnet" "app_vpc_sn" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_cidr_block # 10.0.1.0/24 provides 251 usable IPs (256 - 5 AWS reserved)
  availability_zone = var.availability_zone # Physical data center location - us-east-1a

  # auto-assign public IP addresses for instances launched in this subnet
  map_public_ip_on_launch = true # Instances get public IPs automatically - required for internet access

  # IPv6 configuration
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.app_vpc.ipv6_cidr_block, 8, 1) # Creates /64 block from VPC's /56 block
  assign_ipv6_address_on_creation = true # Instances automatically get IPv6 addresses

  tags = {
    Name = "${var.app_name}-vpc-subnet"
  }
}

# Second subnet for high availability (HA) - explicit configuration
resource "aws_subnet" "subnet_ha_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_ha_2_cidr_block # 10.0.3.0/24 - separate from main subnet
  availability_zone = var.subnet_ha_2_availability_zone # us-east-1b - different AZ for redundancy

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-subnet-2-ha"
  }
}

# enables resources within the subnet to follow the routing policies
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.app_vpc_sn.id # Links subnet to route table
  route_table_id = aws_route_table.app_vpc_rt.id # Traffic follows internet gateway routes
}

# Route table association for ALB subnet
resource "aws_route_table_association" "subnet_ha_2_association" {
  subnet_id      = aws_subnet.subnet_ha_2.id
  route_table_id = aws_route_table.app_vpc_rt.id # Both subnets use same routing - public internet access
}
