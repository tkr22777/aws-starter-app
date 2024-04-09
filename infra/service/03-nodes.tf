# Defines a security group named 'ec2_sg' for EC2 instances within the 'test_env' VPC.
# This security group configures both inbound and outbound traffic rules.
resource "aws_security_group" "ec2_sg" {
    description = "Security Group for EC2"
    vpc_id      = aws_vpc.test_env.id

    # Inbound rule allowing SSH access from any IP address.
    ingress {
        description = "SSH"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    # Inbound rule for HTTP traffic, allowing access from any IP address.
    ingress {
        description = "HTTP"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    # Inbound rule for HTTPS traffic, permitting access from any IP address.
    ingress {
        description = "HTTPS"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        to_port = 443
        protocol = "tcp"
    }

    # Outbound rule allowing all traffic to any destination.
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0     # All ports
        to_port = 0
        protocol = "-1"   # All protocols
    }
}

# # Creates an EC2 instance named 'app_server_001'.
# # This instance is configured with a predefined AMI, instance type, and associated with a specific subnet and security group.
# resource "aws_instance" "app_server_001" {
#   ami           = "ami-00c6c849418b7612c"
#   instance_type = "t2.nano"

#   # the following test_key was defined in aws console's Key Pairs EC2 feature
#   key_name      = "test_key" 

#   subnet_id = "${aws_subnet.app_sn.id}"

#   security_groups = [
#     "${aws_security_group.ec2_sg.id}"
#   ]

#   # script executed on instance initialization.
#   user_data = <<-EOT
#     #!/bin/bash
#     echo 'temp from ec2 init' > /tmp/temp_test.txt
#     sudo yum update
#     sudo yum install -y docker
#     sudo service docker start
#     sudo usermod -a -G docker ec2-user
#     sudo yum install -y postgresql15.x86_64
#   EOT
# }

# # an elastic ip for the app server
# resource "aws_eip" "eip_app_server_001" {
#   instance = "${aws_instance.app_server_001.id}"
#   vpc      = true
# }

# # Example output to get the endpoint
# output "ec2_hostname" {
#   description = "The hostname for the ec2 instance"
#   value       = aws_eip.eip_app_server_001.public_dns
# }