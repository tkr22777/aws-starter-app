resource "aws_ecr_repository" "starter_app" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "starter_app_ecr_repo" {
  description = "The ecr repo url for the starter app"
  value       = aws_ecr_repository.starter_app.repository_url
}