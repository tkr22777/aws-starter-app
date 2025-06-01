# Outputs for ECS resources
output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.app_task.arn
}

output "ecs_target_group_arn" {
  description = "ARN of the ECS target group"
  value       = aws_lb_target_group.ecs_tg.arn
}

output "security_group_ecs_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks_sg.id
}

output "api_path_prefix" {
  description = "Path prefix for ECS service"
  value       = var.api_path_prefix
}

# CLI usage examples
output "useful_commands" {
  description = "Useful AWS CLI commands for ECS management"
  value = <<-EOT

# View running tasks
aws ecs list-tasks --cluster ${aws_ecs_cluster.app_cluster.name} --profile terraform_user

# Describe tasks
aws ecs describe-tasks --cluster ${aws_ecs_cluster.app_cluster.name} --tasks TASK_ARN --profile terraform_user

# View service details
aws ecs describe-services --cluster ${aws_ecs_cluster.app_cluster.name} --services ${aws_ecs_service.app_service.name} --profile terraform_user

# Scale service
aws ecs update-service --cluster ${aws_ecs_cluster.app_cluster.name} --service ${aws_ecs_service.app_service.name} --desired-count 3 --profile terraform_user

# View logs
aws logs tail /ecs/${var.app_name} --follow --profile terraform_user

# Test ECS service (path: ${var.api_path_prefix})
curl ${data.aws_lb.app_alb.dns_name}${var.api_path_prefix == "/*" ? "" : var.api_path_prefix}

# Push new image to ECR
aws ecr get-login-password --region ${data.aws_region.current.name} --profile terraform_user | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com
docker tag your-image:latest ${data.aws_ecr_repository.app_repo.repository_url}:latest
docker push ${data.aws_ecr_repository.app_repo.repository_url}:latest

# Force new deployment (after pushing new image)
aws ecs update-service --cluster ${aws_ecs_cluster.app_cluster.name} --service ${aws_ecs_service.app_service.name} --force-new-deployment --profile terraform_user

EOT
} 