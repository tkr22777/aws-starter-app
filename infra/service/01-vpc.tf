# Creates a Virtual Private Cloud (VPC) named 'test_env'.
# This VPC uses the IP address range 10.0.0.0 to 10.0.255.255 (10.0.0.0/16).
# DNS hostname and support are enabled within this VPC.
resource "aws_vpc" "test_env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

# Attaches an Internet Gateway to the 'test_env' VPC.
# This gateway enables connectivity between the VPC and the internet.
resource "aws_internet_gateway" "test_env_gw" {
  vpc_id = "${aws_vpc.test_env.id}"
}

# Sets up a routing table for the 'test_env' VPC, associated with the Internet Gateway.
# This routing table defines a rule that directs all outbound traffic (0.0.0.0/0) to the Internet Gateway.
# It effectively allows resources within the VPC to access the internet.
resource "aws_route_table" "test_env_rt" {
  vpc_id = "${aws_vpc.test_env.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_env_gw.id}"
  }
}
