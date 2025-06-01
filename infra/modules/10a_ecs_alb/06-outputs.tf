# =============================================================================
# Target Group Outputs
# =============================================================================

output "target_group_arn" {
  description = "ARN of the ECS target group"
  value       = aws_lb_target_group.ecs.arn
}

output "target_group_name" {
  description = "Name of the ECS target group"
  value       = aws_lb_target_group.ecs.name
}

# =============================================================================
# ALB Integration Outputs
# =============================================================================

output "listener_rule_arn" {
  description = "ARN of the ALB listener rule"
  value       = aws_lb_listener_rule.ecs.arn
}

output "listener_rule_priority" {
  description = "Priority of the ALB listener rule"
  value       = aws_lb_listener_rule.ecs.priority
}

output "path_pattern" {
  description = "Path pattern for routing to ECS service"
  value       = var.path_pattern
}

output "host_header" {
  description = "Host header for routing (if configured)"
  value       = var.host_header
}

# =============================================================================
# ECS Service Integration
# =============================================================================

output "ecs_service_name" {
  description = "Name of the ECS service integrated with ALB"
  value       = aws_ecs_service.alb_integration.name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_service.alb_integration.cluster
}

output "container_name" {
  description = "Name of the container receiving traffic"
  value       = var.container_name != "" ? var.container_name : var.app_name
}

output "container_port" {
  description = "Port the container listens on"
  value       = var.container_port
}

# =============================================================================
# Health Check Configuration
# =============================================================================

output "health_check_path" {
  description = "Health check path for the target group"
  value       = var.health_check_path
}

output "health_check_interval" {
  description = "Health check interval in seconds"
  value       = var.health_check_interval
}

# =============================================================================
# ALB Information
# =============================================================================

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = var.alb_arn != "" ? var.alb_arn : data.aws_lb.main[0].arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.alb_arn != "" ? null : data.aws_lb.main[0].dns_name
}

# =============================================================================
# CLI Examples
# =============================================================================

output "test_endpoint" {
  description = "Test endpoint for the ECS service through ALB"
  value       = var.alb_arn == "" ? "http://${data.aws_lb.main[0].dns_name}${var.path_pattern == "/*" ? "" : replace(var.path_pattern, "*", "test")}" : "ALB DNS not available (using provided ARN)"
}

output "target_health_command" {
  description = "AWS CLI command to check target health"
  value       = "aws elbv2 describe-target-health --target-group-arn ${aws_lb_target_group.ecs.arn}"
}

output "listener_rules_command" {
  description = "AWS CLI command to list listener rules"
  value       = "aws elbv2 describe-rules --listener-arn ${var.alb_listener_arn != "" ? var.alb_listener_arn : data.aws_lb_listener.main[0].arn}"
} 