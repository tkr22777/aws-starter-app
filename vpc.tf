# a virtual private cloud where other networked resources will live
resource "aws_vpc" "test_env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

# allows communication between internet and the vpc
resource "aws_internet_gateway" "test_env_gw" {
  vpc_id = "${aws_vpc.test_env.id}"
}

# a routing table associated with the gateway
resource "aws_route_table" "test_env_rt" {
  vpc_id = "${aws_vpc.test_env.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_env_gw.id}"
  }
}
