resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
}

resource "aws_iam_policy" "ecs_user_group_policy" {
  name        = "ecs_user_group_policy"
  description = "A policy for ecs admin user group"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecs:CreateCluster",
        "ecs:DeleteCluster",
        "ecs:DescribeClusters",
        "ecs:RegisterTaskDefinition",
        "ecs:DescribeTaskDefinition",
        "ecs:DeregisterTaskDefinition",
        "ecs:CreateService",
        "ecs:UpdateService",
        "ecs:DeleteService",
        "ecs:DescribeServices",
        "ecs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_group" "terraform_user_group" {
  name = "terraform_user_group"
}

resource "aws_iam_group_policy_attachment" "terraform_user_group_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.ecs_user_group_policy.arn
}

resource "aws_iam_group_membership" "example_membership" {
  name = "example_user_membership"

  users = [
    aws_iam_user.terraform_user.name,
  ]

  group = aws_iam_group.terraform_user_group.name
}