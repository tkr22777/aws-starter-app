resource "aws_security_group" "ec2_sg" {
    description = "Security Group for EC2"
    vpc_id      = aws_vpc.test_env.id

    ingress {
        description = "SSH"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    ingress {
        description = "HTTP"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    ingress {
        description = "HTTPS"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        to_port = 443
        protocol = "tcp"
    }

    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
}

# an ec2 instance
resource "aws_instance" "app_server_001" {
  ami           = "ami-00c6c849418b7612c"
  instance_type = "t2.nano"
  key_name      = "test_key"

  subnet_id = "${aws_subnet.app_sn.id}"

  security_groups = [
    "${aws_security_group.ec2_sg.id}"
  ]

  user_data = <<-EOT
    #!/bin/bash
    echo 'temp from ec2 init' > /tmp/temp_test.txt
    sudo yum update
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo dns install -y postgresql15.x86_64
  EOT
}

# an elastic ip for the app server
resource "aws_eip" "eip_app_server_001" {
  instance = "${aws_instance.app_server_001.id}"
  vpc      = true
}

# Example output to get the endpoint of the RDS
output "ec2_hostname" {
  description = "The hostname for the ec2 instance"
  value       = aws_eip.eip_app_server_001.public_dns
}