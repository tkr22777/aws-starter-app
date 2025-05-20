data "aws_vpc" "app_vpc" {
  filter {
    name   = "tag:name"
    values = ["${var.app_name}-vpc"]
  }
} 

data "aws_subnet" "app_subnet" {
  filter {
    name   = "tag:name"
    values = ["${var.app_name}-vpc-subnet"]
  }
}