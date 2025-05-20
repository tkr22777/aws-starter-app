# Creates a subnet named 'app_sn' within the 'test_env' VPC. 
# This subnet is configured with an IP range of 10.0.1.0 to 10.0.1.255 (10.0.1.0/24), located in the 'us-east-2a' availability zone.
# To change the subnet's range, modify the 'cidr_block' value.
resource "aws_subnet" "app_sn" {
  vpc_id            = aws_vpc.test_env.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

# Associates the 'app_sn' subnet with the 'test_env_rt' route table.
# This enables resources within the subnet to follow the routing policies defined in 'test_env_rt'.
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = "${aws_subnet.app_sn.id}"
  route_table_id = "${aws_route_table.test_env_rt.id}"
}
