# =============================================================================
# Target Group Outputs
# =============================================================================

output "target_group_arn" {
  description = "ARN of the EC2 target group"
  value       = aws_lb_target_group.ec2_tg.arn
}

output "target_group_name" {
  description = "Name of the EC2 target group"
  value       = aws_lb_target_group.ec2_tg.name
}

output "target_group_id" {
  description = "ID of the EC2 target group"
  value       = aws_lb_target_group.ec2_tg.id
}

# =============================================================================
# ALB Integration Outputs
# =============================================================================

output "listener_rule_arn" {
  description = "ARN of the ALB listener rule"
  value       = aws_lb_listener_rule.ec2_rule.arn
}

output "listener_rule_priority" {
  description = "Priority of the ALB listener rule"
  value       = aws_lb_listener_rule.ec2_rule.priority
}

output "api_path_prefix" {
  description = "Path prefix for EC2 service routing"
  value       = var.api_path_prefix
}

# =============================================================================
# Target Group Attachment Outputs
# =============================================================================

output "target_attachment_id" {
  description = "ID of the target group attachment"
  value       = aws_lb_target_group_attachment.ec2_attachment.id
}

output "attached_instance_id" {
  description = "ID of the EC2 instance attached to the target group"
  value       = var.ec2_instance_id
}

output "attached_instance_port" {
  description = "Port of the EC2 instance attached to the target group"
  value       = var.ec2_instance_port
}

# =============================================================================
# CLI Examples
# =============================================================================

# Example AWS CLI commands for verification:
# aws elbv2 describe-target-groups --target-group-arns <target_group_arn>
# aws elbv2 describe-target-health --target-group-arn <target_group_arn>
# aws elbv2 describe-rules --listener-arn <listener_arn>
# aws elbv2 describe-listeners --load-balancer-arn <alb_arn> 