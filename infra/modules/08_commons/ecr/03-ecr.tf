resource "aws_ecr_repository" "app_ecr" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-ecr"
  })
} 