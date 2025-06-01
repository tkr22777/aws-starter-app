# ECR Repository Outputs
output "ecr_repository_url" {
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

output "ecr_registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.app_ecr.registry_id
}

# Useful outputs for integration with other modules
output "registry_url_no_tag" {
  description = "ECR registry URL without tag (useful for docker build)"
  value       = split(":", aws_ecr_repository.app_ecr.repository_url)[0]
}

# CLI commands
output "aws_cli_commands" {
  description = "Useful AWS CLI commands for ECR"
  value = {
    get_login_token = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.app_ecr.repository_url}"
    list_images = "aws ecr list-images --repository-name ${aws_ecr_repository.app_ecr.name}"
    describe_repository = "aws ecr describe-repositories --repository-names ${aws_ecr_repository.app_ecr.name}"
    docker_build_example = "docker build -t ${aws_ecr_repository.app_ecr.repository_url}:latest ."
    docker_push_example = "docker push ${aws_ecr_repository.app_ecr.repository_url}:latest"
  }
}

# Account and region info
output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
} 