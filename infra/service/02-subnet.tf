# subnet (range of ip addresses) within the vpc
resource "aws_subnet" "app_sn" {
  vpc_id = "${aws_vpc.test_env.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = "${aws_subnet.app_sn.id}"
  route_table_id = "${aws_route_table.test_env_rt.id}"
}
