# =============================================================================
# Target Group Outputs
# =============================================================================

output "target_group_arn" {
  description = "ARN of the EC2 target group"
  value       = module.ec2_alb.target_group_arn
}

output "target_group_name" {
  description = "Name of the EC2 target group"
  value       = module.ec2_alb.target_group_name
}

output "target_group_id" {
  description = "ID of the EC2 target group"
  value       = module.ec2_alb.target_group_id
}

# =============================================================================
# ALB Integration Outputs
# =============================================================================

output "listener_rule_arn" {
  description = "ARN of the ALB listener rule"
  value       = module.ec2_alb.listener_rule_arn
}

output "listener_rule_priority" {
  description = "Priority of the ALB listener rule"
  value       = module.ec2_alb.listener_rule_priority
}

output "api_path_prefix" {
  description = "Path prefix for EC2 service routing"
  value       = module.ec2_alb.api_path_prefix
}

# =============================================================================
# Target Group Attachment Outputs
# =============================================================================

output "target_attachment_id" {
  description = "ID of the target group attachment"
  value       = module.ec2_alb.target_attachment_id
}

output "attached_instance_id" {
  description = "ID of the EC2 instance attached to the target group"
  value       = module.ec2_alb.attached_instance_id
}

output "attached_instance_port" {
  description = "Port of the EC2 instance attached to the target group"
  value       = module.ec2_alb.attached_instance_port
}

# =============================================================================
# CLI Usage Examples
# =============================================================================

# Check target group health:
# aws elbv2 describe-target-health --target-group-arn $(terraform output -raw target_group_arn)

# View target group details:
# aws elbv2 describe-target-groups --target-group-arns $(terraform output -raw target_group_arn)

# Test ALB routing (when ALB is deployed):
# curl "http://ALB_DNS_NAME$(terraform output -raw api_path_prefix | sed 's/\*/test')" 