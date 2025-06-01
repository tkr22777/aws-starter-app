# Generate a new 4096-bit RSA SSH key for this EC2 instance
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.app_name}-ec2-key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name = "${var.app_name}-ec2-key"
  }
}

# Save the private key locally for SSH access
resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = pathexpand("~/.ssh/${var.app_name}-ec2-key.pem")
  file_permission = "0400" # Restrictive permissions required for SSH
}

# Output the key details for reference
output "key_name" {
  description = "Name of the SSH key pair in AWS"
  value       = aws_key_pair.generated_key.key_name
}

output "private_key_path" {
  description = "Local path to the private key file"
  value       = local_file.ssh_private_key.filename
} 