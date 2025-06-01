# EC2 instance with Docker for API hosting
resource "aws_instance" "app_server" {
  # Use ECS-optimized AMI with Docker pre-installed (much faster startup)
  ami                     = data.aws_ami.ecs_optimized.id
  instance_type           = var.instance_type
  key_name                = aws_key_pair.generated_key.key_name
  subnet_id               = local.subnet_id
  vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
  
  # Network configuration
  associate_public_ip_address = var.associate_public_ip
  
  # Monitoring configuration
  monitoring = var.enable_detailed_monitoring
  
  # Storage configuration
  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    encrypted   = var.root_volume_encrypted
    delete_on_termination = true
    
    tags = {
      Name = "${var.app_name}-${var.environment}-ec2-root-volume"
    }
  }
  
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
    <p>Environment: ${var.environment}</p>
    <p>Instance Type: ${var.instance_type}</p>
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
    Name = "${var.app_name}-${var.environment}-ec2"
  }
}

# Elastic IP for the EC2 instance (conditional based on public IP requirement)
resource "aws_eip" "app_server_eip" {
  count    = var.associate_public_ip ? 1 : 0
  instance = aws_instance.app_server.id
  domain   = "vpc"
  
  tags = {
    Name = "${var.app_name}-${var.environment}-ec2-eip"
  }
} 