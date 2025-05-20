# security group for an RDS instance within the 'test_env' VPC.
# configures network access rules tailored for database connectivity.
resource "aws_security_group" "rds_sg" {
    description = "Security Group for RDS"
    vpc_id      = data.aws_vpc.app_vpc.id

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
  vpc_id = data.aws_vpc.app_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    name = "${var.app_name}-rds-subnet"
  }
}

# This group is essential for RDS instances to ensure they are placed within the specified subnets for high availability and redundancy.
# To include different subnets, modify the 'subnet_ids' list accordingly.
resource "aws_db_subnet_group" "rds_sng" {
  name       = "${var.app_name}-rds-subnet-group"
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
  identifier           = "${var.app_name}-my-database" # Explicitly set identifier
  db_name              = "postgres"            # DB name
  username             = "postgres"            # DB username
  password             = var.db_password       # Changed to use variable
  parameter_group_name = "default.postgres14"  # Updated parameter group to match version

  # Snapshot and deletion configuration - including both parameters to handle state issues
  skip_final_snapshot  = true                  # Skip final snapshot on deletion for easier resource management
  final_snapshot_identifier = "${var.app_name}-db-final-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_sng.name
  
  multi_az             = false                 # Set to true for multi-AZ deployment
  publicly_accessible  = false                 # Set to false to prevent public access

  tags = {
    name = "${var.app_name}-rds"
  }
}

output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.my_database.endpoint
}

output "db_connection_string" {
  description = "The connection string for the database"
  value       = "psql -h ${split(":", aws_db_instance.my_database.endpoint)[0]} -p 5432 -U postgres -d postgres"
}

