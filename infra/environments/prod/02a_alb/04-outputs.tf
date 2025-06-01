# =============================================================================
# ALB Core Information
# =============================================================================
output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

output "alb_hosted_zone_id" {
  description = "The canonical hosted zone ID of the ALB (for Route53 alias records)"
  value       = module.alb.alb_hosted_zone_id
}

# =============================================================================
# ALB Listener Information
# =============================================================================
output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = module.alb.alb_listener_arn
}

output "default_target_group_arn" {
  description = "The ARN of the default target group"
  value       = module.alb.default_target_group_arn
}

# =============================================================================
# Security Information
# =============================================================================
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.alb.alb_security_group_id
}

# =============================================================================
# Application URLs
# =============================================================================
output "application_url" {
  description = "The application URL (ALB DNS name)"
  value       = module.alb.application_url
}

output "load_balancer_dns" {
  description = "Load balancer DNS name for CNAME records"
  value       = module.alb.load_balancer_dns
}

# =============================================================================
# CLI Examples
# =============================================================================
output "curl_test_command" {
  description = "Command to test the ALB default response"
  value       = module.alb.curl_test_command
}

output "aws_cli_describe_command" {
  description = "AWS CLI command to describe the load balancer"
  value       = module.alb.aws_cli_describe_command
}

output "aws_cli_describe_listeners_command" {
  description = "AWS CLI command to describe ALB listeners"
  value       = module.alb.aws_cli_describe_listeners_command
}

output "aws_cli_describe_target_groups_command" {
  description = "AWS CLI command to describe target groups"
  value       = module.alb.aws_cli_describe_target_groups_command
}

# =============================================================================
# Integration Information
# =============================================================================
output "integration_example" {
  description = "Example configuration for integrating services with this ALB"
  value       = module.alb.integration_example
}

# =============================================================================
# Network Information (for reference)
# =============================================================================
output "vpc_id" {
  description = "VPC ID where ALB is deployed"
  value       = data.terraform_remote_state.network.outputs.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs where ALB is deployed"
  value = [
    data.terraform_remote_state.network.outputs.subnet_id,
    data.terraform_remote_state.network.outputs.subnet_ha_2_id
  ]
} 