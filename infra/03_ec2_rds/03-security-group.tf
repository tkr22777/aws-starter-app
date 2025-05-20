# security group for EC2 instances within the 'turbo_test_vpc' VPC.
resource "aws_security_group" "ec2_sg" {
    description = "Security Group for EC2"
    vpc_id      = data.aws_vpc.app_vpc.id

    # inbound rule allowing SSH access from any IP address.
    ingress {
        description = "SSH"
        cidr_blocks = [var.allowed_ssh_cidr]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    # inbound rule for HTTP traffic, allowing access from any IP address.
    ingress {
        description = "HTTP"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    # inbound rule for HTTPS traffic, permitting access from any IP address.
    ingress {
        description = "HTTPS"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        to_port = 443
        protocol = "tcp"
    }

    # outbound rule allowing all traffic to any destination.
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0     # All ports
        to_port = 0
        protocol = "-1"   # All protocols
    }
}
