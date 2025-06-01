# Data source to get the second HA subnet from network module
data "aws_subnet" "subnet_ha_2" {
  tags = {
    Name = "${var.app_name}-subnet-2-ha"
  }
}

# DB subnet group for RDS instances
# This group is essential for RDS instances to ensure they are placed within the specified subnets
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.app_name}-rds-subnet-group-shared"
  subnet_ids = [
    data.aws_subnet.app_subnet.id,
    data.aws_subnet.subnet_ha_2.id
  ]
  
  tags = {
    Name = "${var.app_name}-rds-subnet-group-shared"
  }
}

# RDS instance
resource "aws_db_instance" "database" {
  allocated_storage    = 20                    # 20 GB, adjust as needed
  storage_type         = "gp2"                 # General Purpose storage
  engine               = "postgres"            # PostgreSQL engine
  engine_version       = "14.15"               # PostgreSQL 14.15
  instance_class       = "db.t3.micro"         # Instance class, choose based on needs
  identifier           = "${var.app_name}-database" # Explicitly set identifier
  db_name              = "postgres"            # DB name
  username             = "postgres"            # DB username
  password             = var.db_password       # Password from variable
  parameter_group_name = "default.postgres14"  # Parameter group to match version

  # Snapshot and deletion configuration
  skip_final_snapshot  = true                  # Skip final snapshot on deletion for easier resource management

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  
  multi_az             = false                 # Set to true for multi-AZ deployment
  publicly_accessible  = false                 # Set to false to prevent public access

  tags = {
    Name = "${var.app_name}-rds"
  }
}

# Outputs
output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.database.endpoint
}

output "db_connection_string" {
  description = "The connection string for the database"
  value       = "psql -h ${split(":", aws_db_instance.database.endpoint)[0]} -p 5432 -U postgres -d postgres"
}

output "db_instance_id" {
  description = "The ID of the database instance"
  value       = aws_db_instance.database.id
}

output "db_subnet_group_name" {
  description = "The name of the database subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.name
} 