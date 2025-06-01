# Data sources to reference network module resources

data "aws_vpc" "app_vpc" {
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

data "aws_subnet" "main_subnet" {
  tags = {
    Name = "${var.app_name}-vpc-subnet"
  }
}

data "aws_subnet" "subnet_ha_2" {
  tags = {
    Name = "${var.app_name}-subnet-2-ha"
  }
} 