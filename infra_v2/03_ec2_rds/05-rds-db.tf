# security group for an RDS instance within the 'test_env' VPC.
# configures network access rules tailored for database connectivity.
resource "aws_security_group" "rds_sg" {
    description = "Security Group for RDS"
    vpc_id      = data.aws_vpc.turbo_test_vpc.id

    # allow incoming traffic from EC2 to PostgreSQL
    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        security_groups = [aws_security_group.ec2_sg.id]
    }
}

# an additional subnet named 'rds_subnet' within the 'test_env' VPC for RDS usage
# configured with an IP range of 10.0.2.0 to 10.0.2.255 (10.0.2.0/24), located in the 'us-east-1b' availability zone.
resource "aws_subnet" "rds_subnet" {
  vpc_id = data.aws_vpc.turbo_test_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    name = "${var.app_name}_rds_subnet"
  }
}

# This group is essential for RDS instances to ensure they are placed within the specified subnets for high availability and redundancy.
# To include different subnets, modify the 'subnet_ids' list accordingly.
resource "aws_db_subnet_group" "rds_sng" {
  name       = "${var.app_name}_rds_subnet_group"
  subnet_ids = [
    data.aws_subnet.app_subnet.id,
    aws_subnet.rds_subnet.id
  ] 
}

# RDS instance
resource "aws_db_instance" "my_database" {
  allocated_storage    = 20                    # 20 GB, adjust as needed
  storage_type         = "gp2"                 # General Purpose storage
  engine               = "postgres"            # PostgreSQL engine
  engine_version       = "14.15"               # Changed to PostgreSQL 14.10
  instance_class       = "db.t3.micro"         # Instance class, choose based on needs
  db_name              = "postgres"            # DB name
  username             = "postgres"            # DB username
  password             = "abcd1234"            # DB password
  parameter_group_name = "default.postgres14"  # Updated parameter group to match version

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_sng.name

  skip_final_snapshot  = true                  # Skip final snapshot when deleting the DB
  multi_az             = false                 # Set to true for multi-AZ deployment
  publicly_accessible  = false                 # Set to false to prevent public access
}

