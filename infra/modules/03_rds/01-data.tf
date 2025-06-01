data "aws_vpc" "app_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc"]
  }
}

data "aws_subnet" "app_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc-subnet"]
  }
}

locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc.id
  subnet_id = length(var.subnet_ids) > 0 ? var.subnet_ids[0] : data.aws_subnet.app_subnet.id
} 