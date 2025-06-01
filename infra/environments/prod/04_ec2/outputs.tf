# =============================================================================
# EC2 Instance Outputs
# =============================================================================

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "instance_type" {
  description = "The type of the EC2 instance"
  value       = module.ec2.instance_type
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2.instance_private_ip
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_hostname" {
  description = "The public hostname for the EC2 instance"
  value       = module.ec2.ec2_hostname
}

# =============================================================================
# Security and Access Outputs
# =============================================================================

output "security_group_id" {
  description = "The ID of the EC2 security group"
  value       = module.ec2.security_group_id
}

output "ssh_connection_string" {
  description = "Command to connect to the EC2 instance via SSH"
  value       = module.ec2.ssh_connection_string
}

output "key_pair_name" {
  description = "The name of the SSH key pair"
  value       = module.ec2.key_pair_name
}

# =============================================================================
# CLI Usage Examples
# =============================================================================

# Connect to EC2 instance:
# terraform output ssh_connection_string | sh

# Check instance status:
# aws ec2 describe-instances --instance-ids $(terraform output -raw instance_id)

# View security group rules:
# aws ec2 describe-security-groups --group-ids $(terraform output -raw security_group_id)

# Test API endpoint directly:
# curl http://$(terraform output -raw public_ip)

# Download SSH key and connect:
# aws ec2 describe-key-pairs --key-names $(terraform output -raw key_pair_name)
# ssh -i ~/.ssh/$(terraform output -raw key_pair_name).pem ec2-user@$(terraform output -raw public_ip) 