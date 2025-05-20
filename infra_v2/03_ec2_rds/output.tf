output "ec2_hostname" {
  description = "The hostname for the ec2 instance"
  value       = aws_eip.eip_app_server_001.public_dns
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_eip.eip_app_server_001.public_ip
}

output "ssh_connection_string" {
  description = "Command to connect to the EC2 instance via SSH"
  value       = "ssh -o StrictHostKeyChecking=no -i ~/.ssh/${aws_key_pair.generated_key.key_name}.pem ubuntu@${aws_eip.eip_app_server_001.public_ip}"
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server_001.id
} 

output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.my_database.endpoint
}

output "db_connection_string" {
  description = "The connection string for the database"
  value       = "psql -h ${split(":", aws_db_instance.my_database.endpoint)[0]} -p 5432 -U postgres -d postgres"
}