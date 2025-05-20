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