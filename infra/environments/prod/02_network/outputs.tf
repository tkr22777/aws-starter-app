output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = module.network.private_subnet_ids
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC"
  value       = module.network.vpc_cidr_block
} 