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

## Resource Discovery & Data Source Filtering

This module uses a flexible resource discovery mechanism that can work with either explicit resource IDs or automatic discovery via AWS tags.

### How Resource Discovery Works

The module uses conditional data sources that only activate when explicit resource IDs are not provided:

1. **VPC Discovery**: When `vpc_id` variable is empty (`""`), the module searches for a VPC with these tags:
   ```hcl
   Name        = "${var.app_name}-vpc"
   Environment = "${var.environment}"
   ```

2. **Subnet Discovery**: When `subnet_ids` variable is empty (`[]`), the module searches for subnets with these tags:
   ```hcl
   # Primary subnet
   Name        = "${var.app_name}-vpc-subnet"
   Environment = "${var.environment}"
   
   # High availability subnet  
   Name        = "${var.app_name}-subnet-2-ha"
   Environment = "${var.environment}"
   ```

### Expected Resource Tags

For automatic discovery to work, your network resources must be tagged consistently:

| Resource Type | Expected Tag: Name | Expected Tag: Environment |
|---------------|-------------------|---------------------------|
| VPC | `{app_name}-vpc` | `{environment}` |
| Primary Subnet | `{app_name}-vpc-subnet` | `{environment}` |
| HA Subnet | `{app_name}-subnet-2-ha` | `{environment}` |

### Fallback Mechanism

The module uses local values to prioritize explicit IDs over discovered resources:

```hcl
locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : [
    data.aws_subnet.app_subnet[0].id,
    data.aws_subnet.subnet_ha_2[0].id
  ]
}
```

This means:
- If you provide `vpc_id` and `subnet_ids` variables, those will be used directly
- If variables are empty, the module will search for resources using the expected tags
- If using with remote state (recommended), the environment layer handles the resource discovery

### Remote State Integration

When used with the environment structure (`infra/environments/prod/03_rds/`), the module typically receives resource IDs from remote state rather than using data source discovery:

```hcl
# In environment main.tf
vpc_id     = local.vpc_id      # From network module remote state
subnet_ids = local.subnet_ids  # From network module remote state
```

## Implementation Approach

This module follows Terraform best practices by using **remote state as the primary method** for resource discovery, with tag-based data source filtering as a fallback mechanism.

### Why This Design

- **Primary**: `terraform_remote_state` provides reliable, fast, and secure module-to-module communication
- **Fallback**: Data source discovery enables module flexibility and legacy resource integration
- **Best Practice**: This hybrid approach aligns with HashiCorp recommendations for production infrastructure

### Resource Discovery Priority

1. **Remote state** (when environment provides `vpc_id`/`subnet_ids`)
2. **Tag-based discovery** (when variables are empty - fallback only)

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