# Look up the EC2 security group by name tag
data "aws_security_group" "ec2_sg" {
  count = var.ec2_security_group_id == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-ec2-sg"]
  }
}

# Look up the RDS security group by name tag
data "aws_security_group" "rds_sg" {
  count = var.rds_security_group_id == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-rds-sg"]
  }
}

# Use the provided security group IDs if specified, otherwise use data sources
locals {
  ec2_sg_id = var.ec2_security_group_id != "" ? var.ec2_security_group_id : data.aws_security_group.ec2_sg[0].id
  rds_sg_id = var.rds_security_group_id != "" ? var.rds_security_group_id : data.aws_security_group.rds_sg[0].id
} 