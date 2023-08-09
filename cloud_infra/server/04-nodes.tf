# an ec2 instance
resource "aws_instance" "app_server_001" {
  ami           = "ami-00c6c849418b7612c"
  instance_type = "t2.nano"
  key_name      = "test_key"

  subnet_id = "${aws_subnet.app_sn.id}"

  security_groups = [
    "${aws_security_group.ingress_allow_all_test.id}"
  ]
}

# an elastic ip for the app server
resource "aws_eip" "eip_app_server_001" {
  instance = "${aws_instance.app_server_001.id}"
  vpc      = true
}