# subnet (range of ip addresses) within the vpc
resource "aws_subnet" "app-subnet" {
  cidr_block = "${cidrsubnet(aws_vpc.test_env.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.test_env.id}"
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.app-subnet.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}
