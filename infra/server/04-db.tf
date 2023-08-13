resource "aws_security_group" "rds_sg" {
    description = "Security Group for RDS"
    vpc_id      = aws_vpc.test_env.id

    # allow incoming traffic from EC2 to PostgreSQL
    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        security_groups = [aws_security_group.ec2_sg.id]
    }
}

# allow outgoing traffic from EC2 to PostgreSQL
# seperately created to avoid cycle error
resource "aws_security_group_rule" "extra_rule" {
  security_group_id        = "${aws_security_group.ec2_sg.id}"  # target security group
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  type                     = "egress"
  source_security_group_id = "${aws_security_group.ec2_sg.id}"
}

# extra subnet required for db_subnet_group
resource "aws_subnet" "rds_subnet" {
  vpc_id = "${aws_vpc.test_env.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_db_subnet_group" "rds_sng" {
  name       = "rds_sng"
  subnet_ids = ["${aws_subnet.app_sn.id}", "${aws_subnet.rds_subnet.id}"] # Your subnet IDs here
}

# RDS instance
resource "aws_db_instance" "my_database" {
  allocated_storage    = 20                    # 20 GB, adjust as needed
  storage_type         = "gp2"                 # General Purpose storage
  engine               = "postgres"            # PostgreSQL engine
  engine_version       = "13.11"                # Specific PostgreSQL version
  instance_class       = "db.t3.micro"         # Instance class, choose based on needs
  db_name              = "postgres"            # DB name
  username             = "postgres"                # DB username
  password             = "abcd1234"            # DB password
  parameter_group_name = "default.postgres13"  # Default parameter group for PostgreSQL 13

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_sng.name

  skip_final_snapshot  = true                  # Skip final snapshot when deleting the DB
  multi_az             = false                 # Set to true for multi-AZ deployment
  publicly_accessible  = false                 # Set to false to prevent public access
}

output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.my_database.endpoint
}