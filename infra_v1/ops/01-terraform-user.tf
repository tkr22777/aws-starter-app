resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
}

resource "aws_iam_group_membership" "example_membership" {
  name = "example_user_membership"

  users = [
    aws_iam_user.terraform_user.name,
  ]

  group = aws_iam_group.terraform_user_group.name
}