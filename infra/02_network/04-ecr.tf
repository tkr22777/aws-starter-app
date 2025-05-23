resource "aws_ecr_repository" "app_ecr" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = {
    Name = "${var.app_name}-ecr"
  }
}

# Outputs for the ECR repository
output "ecr_repo_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app_ecr.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.app_ecr.arn
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.app_ecr.name
}