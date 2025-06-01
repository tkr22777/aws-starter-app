# =============================================================================
# ECS Cluster Outputs
# =============================================================================

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.arn
}

# =============================================================================
# ECS Service Outputs
# =============================================================================

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.app_service.id
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.app_task.arn
}

output "task_definition_family" {
  description = "Family of the task definition"
  value       = aws_ecs_task_definition.app_task.family
}

# =============================================================================
# Network Outputs
# =============================================================================

output "security_group_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks_sg.id
}

output "vpc_id" {
  description = "VPC ID where ECS service is deployed"
  value       = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
}

output "subnet_id" {
  description = "Subnet ID where ECS tasks are deployed"
  value       = var.subnet_id != "" ? var.subnet_id : data.aws_subnet.main_subnet[0].id
}

# =============================================================================
# Container Information
# =============================================================================

output "container_image" {
  description = "Container image used by the service"
  value       = var.container_image != "" ? var.container_image : "${data.aws_ecr_repository.app_repo[0].repository_url}:${var.container_tag}"
}

output "container_port" {
  description = "Port the container listens on"
  value       = var.container_port
}

# =============================================================================
# Auto Scaling Outputs
# =============================================================================

output "auto_scaling_enabled" {
  description = "Whether auto scaling is enabled"
  value       = var.enable_auto_scaling
}

output "auto_scaling_target_arn" {
  description = "ARN of the auto scaling target (if enabled)"
  value       = var.enable_auto_scaling ? aws_appautoscaling_target.ecs_target[0].arn : null
}

# =============================================================================
# CloudWatch Logs
# =============================================================================

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_log_group.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_log_group.arn
}

# =============================================================================
# CLI Examples
# =============================================================================

output "ecs_exec_command" {
  description = "AWS CLI command to execute commands in the container"
  value       = "aws ecs execute-command --cluster ${aws_ecs_cluster.app_cluster.name} --task <task-id> --container ${var.app_name} --interactive --command '/bin/bash'"
}

output "logs_command" {
  description = "AWS CLI command to view logs"
  value       = "aws logs tail ${aws_cloudwatch_log_group.ecs_log_group.name} --follow"
}

output "service_status_command" {
  description = "AWS CLI command to check service status"
  value       = "aws ecs describe-services --cluster ${aws_ecs_cluster.app_cluster.name} --services ${aws_ecs_service.app_service.name}"
} 