resource "aws_subnet" "turbo_test_vpc_sn" {
  vpc_id            = aws_vpc.turbo_test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  
  # auto-assign public IP addresses for instances launched in this subnet
  map_public_ip_on_launch = true

  # IPv6 configuration
  ipv6_cidr_block = cidrsubnet(aws_vpc.turbo_test_vpc.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  tags = {
    name = "${var.app_name}_vpc_subnet"
  }
}

# enables resources within the subnet to follow the routing policies
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.turbo_test_vpc_sn.id
  route_table_id = aws_route_table.turbo_test_vpc_rt.id
}
