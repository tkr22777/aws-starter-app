# EC2 instance 
resource "aws_instance" "app_server" {
  # ubuntu-pro-server/images/hvm-ssd/ubuntu-focal-20.04-amd64-pro-server-20250109
  ami           = "ami-025d2d68592b89c80" 
  instance_type = var.instance_type

  # SSH key for remote access
  key_name      = aws_key_pair.generated_key.key_name

  subnet_id = data.aws_subnet.app_subnet.id
  security_groups = [aws_security_group.ec2_sg.id]

  # This will replace the instance if user_data changes
  user_data_replace_on_change = true  

  user_data = <<-EOT
#!/bin/bash
echo "Executing user data script...";
sudo apt-get update;
sudo apt-get install -y postgresql-client;
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable";
sudo apt-get update;
sudo apt-get install -y docker-ce docker-ce-cli containerd.io;
sudo systemctl start docker;
sudo systemctl enable docker;
sudo usermod -aG docker ubuntu;
EOT

  tags = {
    Name = "${var.app_name}-ec2"
  }
}

# Elastic IP for the EC2 instance
resource "aws_eip" "app_server_eip" {
  instance = aws_instance.app_server.id
  vpc      = true
  
  tags = {
    Name = "${var.app_name}-ec2-eip"
  }
}

# Outputs
output "ec2_hostname" {
  description = "The hostname for the EC2 instance"
  value       = aws_eip.app_server_eip.public_dns
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_eip.app_server_eip.public_ip
}

output "ssh_connection_string" {
  description = "Command to connect to the EC2 instance via SSH"
  value       = "ssh -o StrictHostKeyChecking=no -i ~/.ssh/${aws_key_pair.generated_key.key_name}.pem ubuntu@${aws_eip.app_server_eip.public_ip}"
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
} 