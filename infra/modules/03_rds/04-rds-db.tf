# DB subnet group for RDS instances
# This group is essential for RDS instances to ensure they are placed within the specified subnets
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.app_name}-${var.environment}-rds-subnet-group"
  subnet_ids = local.subnet_ids

  tags = {
    Name = "${var.app_name}-${var.environment}-rds-subnet-group"
  }
}

# RDS instance
resource "aws_db_instance" "database" {
  allocated_storage    = 20                                            # 20 GB, adjust as needed
  storage_type         = "gp2"                                         # General Purpose storage
  engine               = "postgres"                                    # PostgreSQL engine
  engine_version       = "14.15"                                       # PostgreSQL 14.15
  instance_class       = "db.t3.micro"                                 # Instance class, choose based on needs
  identifier           = "${var.app_name}-${var.environment}-database" # Explicitly set identifier
  db_name              = "postgres"                                    # DB name
  username             = "postgres"                                    # DB username
  password             = var.db_password                               # Password from variable
  parameter_group_name = "default.postgres14"                          # Parameter group to match version

  # Snapshot and deletion configuration
  skip_final_snapshot = true # Skip final snapshot on deletion for easier resource management

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  multi_az            = false # Set to true for multi-AZ deployment
  publicly_accessible = false # Set to false to prevent public access

  tags = {
    Name = "${var.app_name}-${var.environment}-rds"
  }
} 