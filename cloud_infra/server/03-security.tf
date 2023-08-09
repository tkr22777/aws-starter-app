resource "aws_security_group" "ingress_allow_all_test" {
    vpc_id = "${aws_vpc.test_env.id}"

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
