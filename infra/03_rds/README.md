# RDS PostgreSQL Database

This module provisions an RDS PostgreSQL database instance with required networking components.

## Resources Created

- **RDS Database Instance** (`aws_db_instance.database`)
  - PostgreSQL 14.15 database engine
  - Configurable storage and instance type
  - Secure password management via variable input

- **Database Security Group** (`aws_security_group.rds_sg`)
  - Defines access controls for the database
  - By default, no ingress rules are created (other modules can add rules as needed)
  - Uses tag `${var.app_name}-rds-sg` for automatic discovery by other modules

- **DB Subnet Group** (`aws_db_subnet_group.rds_subnet_group`)
  - Spans multiple availability zones for high availability
  - Utilizes existing and new subnets

- **Additional RDS Subnet** (`aws_subnet.rds_subnet`)
  - Located in a different AZ from the main application subnet
  - Required for DB subnet group creation

## Usage

```hcl
module "rds" {
  source = "../03_rds"
  
  app_name    = "your-app-name"
  db_password = "your-secure-password"
}
```

The module automatically finds the VPC and subnet resources based on standard naming conventions (`${var.app_name}-vpc` and `${var.app_name}-vpc-subnet`).

## Connecting to the Database

- **Endpoint**: Use the `db_endpoint` output from Terraform.
- **Connection String**: Use the `db_connection_string` output for psql:
  ```bash
  # Example: psql -h <db_endpoint_address> -p 5432 -U postgres -d postgres
  ```

## Security Considerations

- The default configuration sets `publicly_accessible = false` to restrict public internet access
- Credentials are managed through variables (not hardcoded)
- Consider adding encryption and backup configurations for production use

## Outputs

| Name | Description |
|------|-------------|
| `db_endpoint` | Connection endpoint for the database |
| `db_connection_string` | Ready-to-use psql connection string |
| `db_instance_id` | Resource ID of the database instance |
| `rds_security_group_id` | ID of the security group protecting the database |
| `db_subnet_group_name` | Name of the database subnet group |
| `rds_subnet_id` | ID of the additional subnet created for RDS | 