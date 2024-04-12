resource "aws_iam_group" "terraform_user_group" {
  name = "terraform_user_group"
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
        "iam:*",
        "ec2:*",
        "rds:*",
        "ecr:*",
        "ecs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "terraform_user_group_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.ecs_user_group_policy.arn
}