# EC2 Instance

This module provisions an EC2 instance with an associated SSH key pair and networking configurations.

## Resources Created

- **EC2 Instance** (`aws_instance.app_server`)
  - Ubuntu 20.04 LTS image
  - Configurable instance type (default: t3a.small)
  - User data script installs Docker and PostgreSQL client

- **Security Group** (`aws_security_group.ec2_sg`)
  - Allows inbound SSH from configurable CIDR
  - Allows inbound HTTP/HTTPS from anywhere
  - Allows all outbound traffic

- **SSH Key Pair**
  - Generates a new 4096-bit RSA key pair
  - Saves the private key locally to `~/.ssh/[app_name]-ec2-key.pem`
  - Associates the public key with the EC2 instance

- **Elastic IP** (`aws_eip.app_server_eip`)
  - Provides a static, public IP address
  - Remains constant even if the instance is stopped/started

## Usage

```hcl
module "ec2" {
  source = "../04_ec2"
  
  app_name         = "your-app-name"
  allowed_ssh_cidr = "123.123.123.123/32"  # Your IP address for secure SSH access
}
```

The module automatically:
- Discovers the VPC and subnet from the network module using consistent naming
- Finds the RDS security group for automatic database connectivity
- Creates appropriate security group rules between resources

## Accessing the Instance

- **SSH Connection**: Use the `ssh_connection_string` output from Terraform to connect:
  ```bash
  # Example: ssh -o StrictHostKeyChecking=no -i ~/.ssh/your-app-name-ec2-key.pem ubuntu@<public_ip>
  ```
  Ensure the key file has `chmod 400` permissions for proper security.

## Serving HTTP/HTTPS Traffic

The EC2 security group includes inbound rules for ports 80 and 443, allowing HTTP and HTTPS traffic from any source. To serve web content:

1. Install a web server (the instance already has Docker installed via user data script)
2. Configure your application to listen on the appropriate ports
3. Use the `public_ip` or `ec2_hostname` outputs to access your application

## Database Connectivity

This module automatically creates a security group rule allowing the EC2 instance to connect to the RDS database on port 5432, which it discovers through the standard tag name `{app_name}-rds-sg`.

## Outputs

| Name | Description |
|------|-------------|
| `ec2_hostname` | Public DNS name of the instance |
| `public_ip` | Public IP address of the instance |
| `ssh_connection_string` | Ready-to-use SSH connection command |
| `instance_id` | Resource ID of the EC2 instance |
| `security_group_id` | ID of the EC2 security group | 