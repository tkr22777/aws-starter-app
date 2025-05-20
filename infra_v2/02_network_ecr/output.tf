output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.turbo_test_vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.turbo_test_vpc.cidr_block
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.turbo_test_vpc_sn.id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.turbo_test_vpc_rt.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.turbo_test_vpc_gw.id
} 