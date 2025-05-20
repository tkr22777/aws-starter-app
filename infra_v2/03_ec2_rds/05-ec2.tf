# creates an EC2 instance named 'app_server_001'.
# this instance is configured with a predefined AMI,
# instance type, and associated with a specific subnet and security group.
resource "aws_instance" "app_server_001" {

  # ubuntu-pro-server/images/hvm-ssd/ubuntu-focal-20.04-amd64-pro-server-20250109
  ami           = "ami-025d2d68592b89c80" 
  instance_type = "t3a.small" # 2 vCPUs, 4GB RAM

  # key for ssh access
  key_name      = aws_key_pair.generated_key.key_name

  subnet_id = data.aws_subnet.app_subnet.id

  security_groups = [
    aws_security_group.ec2_sg.id
  ]

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
    name = "${var.app_name}_ec2"
  }
}

# an elastic ip for the app server
resource "aws_eip" "eip_app_server_001" {
  instance = "${aws_instance.app_server_001.id}"
  vpc      = true
}