# Generate a private key
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair in AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.app_name}_ec2_key"
  public_key = tls_private_key.generated_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  filename        = pathexpand("~/.ssh/${aws_key_pair.generated_key.key_name}.pem")
  content         = tls_private_key.generated_key.private_key_pem
  file_permission = "0400"
} 