# EC2 Instance and RDS Database

This module provisions an EC2 instance with an associated SSH key pair and an RDS PostgreSQL database instance.

## EC2 Instance (`aws_instance.app_server_001`)

### Accessing the Instance
- **SSH Key**: A new SSH key pair is generated.
  - The private key is saved locally by Terraform to `~/.ssh/${var.app_name}-ec2-key.pem`. Ensure this path is correct and the key has `chmod 400` permissions.
  - The public key is associated with the EC2 instance.
- **SSH Connection**: Use the `ssh_connection_string` output from Terraform to connect:
  ```bash
  # Example: ssh -o StrictHostKeyChecking=no -i ~/.ssh/your-app-name-ec2-key.pem ubuntu@<public_ip>
  ```

### Serving HTTP/HTTPS Traffic
- **Security Group**: The EC2 security group (`aws_security_group.ec2_sg`) controls inbound traffic.
  - By default, it allows SSH (port 22) and ICMP.
  - To serve HTTP/HTTPS, you must add ingress rules for port 80/443 to this security group, typically allowing `0.0.0.0/0` or a specific source.
- **Web Server**: You need to install and configure a web server (e.g., Nginx, Apache) or application server on the EC2 instance to listen on these ports.
  - The instance `user_data` script installs Docker, allowing deployment of containerized web applications.

### Instance Initialization Note
- The instance `user_data` script installs `postgresql-client` and `docker`.
- Verify script execution via system logs (`/var/log/cloud-init-output.log`) if issues arise.

## RDS PostgreSQL Database (`aws_db_instance.my_database`)

### Connecting to the Database
- **Endpoint**: Use the `db_endpoint` output from Terraform.
- **Connection String**: Use the `db_connection_string` output for psql:
  ```bash
  # Example: psql -h <db_endpoint_address> -p 5432 -U postgres -d postgres
  # The default password is "abcd1234" (ensure this is managed securely, e.g., via secrets manager in production).
  ```
- **From EC2**: The EC2 instance can connect to the RDS instance because the RDS security group (`aws_security_group.rds_sg`) allows inbound traffic on port 5432 from the EC2 security group.
- **From Local/Other Sources**: To connect from your local machine or other non-EC2 sources, you would need to:
  1. Modify the RDS security group to allow inbound traffic from your IP address on port 5432.
  2. Ensure the RDS instance is configured to be publicly accessible if connecting over the internet (current setting makes it only accessible from within the VPC).
