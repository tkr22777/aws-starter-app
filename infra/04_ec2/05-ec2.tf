# EC2 instance with Docker for API hosting
resource "aws_instance" "app_server" {
  # Use ECS-optimized AMI with Docker pre-installed (much faster startup)
  ami           = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id     = data.aws_subnet.app_subnet.id
  
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  # Associate public IP 
  associate_public_ip_address = true
  
  # This will replace the instance if user_data changes
  user_data_replace_on_change = true  

  user_data = <<-EOT
#!/bin/bash
echo "Executing minimal user data script...";

# Simple HTML page for API endpoint (nginx not needed - can use simple python server)
mkdir -p /home/ec2-user/app
cat > /home/ec2-user/app/index.html <<HTML
<!DOCTYPE html>
<html>
<head>
    <title>${var.app_name} EC2 API</title>
</head>
<body>
    <h1>EC2 API Service</h1>
    <p>This is the EC2-based API service for ${var.app_name}</p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Path: ${var.api_path_prefix}</p>
</body>
</html>
HTML

# Start simple HTTP server (no nginx needed)
cd /home/ec2-user/app && python3 -m http.server 80 > /var/log/python-server.log 2>&1 &

echo "User data script completed successfully";
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

output "ec2_target_group_arn" {
  description = "ARN of the EC2 target group"
  value       = aws_lb_target_group.ec2_tg.arn
}

output "api_path_prefix" {
  description = "Path prefix for EC2 service"
  value       = var.api_path_prefix
} 