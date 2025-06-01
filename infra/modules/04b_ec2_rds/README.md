# EC2-RDS Connectivity

This module manages the network connectivity between EC2 instances and RDS databases.

## Overview

This module creates security group rules to allow:
- Inbound PostgreSQL (port 5432) traffic from EC2 instances to RDS databases

By separating these connectivity rules into their own module, we achieve:
1. Clear separation of concerns
2. Ability to deploy each service independently
3. Centralized management of cross-service connectivity

## Prerequisites

The module requires:
- EC2 security groups with appropriate tags
- RDS security groups with appropriate tags

## Usage

```hcl
module "ec2_rds_connectivity" {
  source = "../05_ec2_rds"
  
  app_name = "your-app-name"
  
  # Optional - use these only if your security groups aren't discoverable via tags
  # ec2_security_group_id = "sg-1234abcd"
  # rds_security_group_id = "sg-5678efgh"
}
```

## Outputs

| Name | Description |
|------|-------------|
| `ec2_sg_id` | EC2 security group ID |
| `rds_sg_id` | RDS security group ID |
| `rule_id` | Security group rule ID 