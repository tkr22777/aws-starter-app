resource "aws_ecr_repository" "user_setting_app" {
  name                 = "user_setting_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {}
}

output "user_setting_app_ecr_repo" {
  description = "The ecr repo url for the user_setting_app_images"
  value       = aws_ecr_repository.user_setting_app.repository_url
}