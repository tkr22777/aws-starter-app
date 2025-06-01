# =============================================================================
# EC2 Instance Outputs
# =============================================================================

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_type" {
  description = "The type of the EC2 instance"
  value       = aws_instance.app_server.instance_type
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.app_server.private_ip
}

output "instance_private_dns" {
  description = "The private DNS hostname of the EC2 instance"
  value       = aws_instance.app_server.private_dns
}

# =============================================================================
# Public Access Outputs (Conditional)
# =============================================================================

output "public_ip" {
  description = "The public IP address of the EC2 instance (if EIP is attached)"
  value       = var.associate_public_ip ? aws_eip.app_server_eip[0].public_ip : null
}

output "ec2_hostname" {
  description = "The public hostname for the EC2 instance (if EIP is attached)"
  value       = var.associate_public_ip ? aws_eip.app_server_eip[0].public_dns : null
}

output "ssh_connection_string" {
  description = "Command to connect to the EC2 instance via SSH (if SSH is enabled and EIP exists)"
  value       = var.enable_ssh_access && var.associate_public_ip ? "ssh -o StrictHostKeyChecking=no -i ~/.ssh/${aws_key_pair.generated_key.key_name}.pem ec2-user@${aws_eip.app_server_eip[0].public_ip}" : "SSH access disabled or no public IP"
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

# =============================================================================
# SSH Key Outputs
# =============================================================================

output "key_pair_name" {
  description = "The name of the generated key pair"
  value       = aws_key_pair.generated_key.key_name
}

# =============================================================================
# CLI Examples
# =============================================================================

# Example AWS CLI commands for verification:
# aws ec2 describe-instances --instance-ids <instance_id>
# aws ec2 describe-security-groups --group-ids <security_group_id>
# aws ec2 describe-key-pairs --key-names <key_pair_name>
# curl http://<public_ip> (test direct access) 