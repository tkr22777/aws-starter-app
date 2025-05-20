data "aws_vpc" "turbo_test_vpc" {
  filter {
    name   = "tag:name"
    values = ["${var.app_name}_vpc"]
  }
} 

data "aws_subnet" "app_subnet" {
  filter {
    name   = "tag:name"
    values = ["${var.app_name}_vpc_subnet"]
  }
}