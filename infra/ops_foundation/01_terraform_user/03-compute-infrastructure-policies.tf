# =============================================================================
# Compute Infrastructure Management Policy (EC2 + ECS + ECR)
# =============================================================================

resource "aws_iam_policy" "compute_infrastructure_policy" {
  name        = "terraform_user_compute_infrastructure_policy"
  description = "Policy for EC2, ECS, VPC networking, application autoscaling, and ECR container registry management"
  
  tags = {
    Name = "terraform_user_compute_infrastructure_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2Management",
        Effect = "Allow",
        Action = [
          "ec2:CreateTags", "ec2:DeleteTags", "ec2:RunInstances",
          "ec2:TerminateInstances", "ec2:StopInstances", "ec2:StartInstances",
          "ec2:RebootInstances", "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
          "ec2:GetSecurityGroupsForVpc", "ec2:CreateKeyPair", "ec2:DeleteKeyPair",
          "ec2:ImportKeyPair", "ec2:CreateVolume", "ec2:DeleteVolume",
          "ec2:AttachVolume", "ec2:DetachVolume", "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot", "ec2:CopySnapshot", "ec2:CreateImage",
          "ec2:DeregisterImage", "ec2:AllocateAddress", "ec2:ReleaseAddress",
          "ec2:AssociateAddress", "ec2:DisassociateAddress"
        ],
        Resource = "*"
      },
      {
        Sid    = "VPCNetworkingManagement",
        Effect = "Allow",
        Action = [
          "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:ModifySubnetAttribute",
          "ec2:CreateVpc", "ec2:DeleteVpc", "ec2:ModifyVpcAttribute",
          "ec2:AssociateVpcCidrBlock", "ec2:DisassociateVpcCidrBlock",
          "ec2:CreateInternetGateway", "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway", "ec2:DetachInternetGateway",
          "ec2:CreateRouteTable", "ec2:DeleteRouteTable",
          "ec2:CreateRoute", "ec2:DeleteRoute", "ec2:ReplaceRoute",
          "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable"
        ],
        Resource = "*"
      },
      {
        Sid    = "ECSManagement",
        Effect = "Allow",
        Action = [
          "ecs:CreateCluster", "ecs:DeleteCluster", "ecs:CreateService",
          "ecs:UpdateService", "ecs:DeleteService", "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition", "ecs:RunTask", "ecs:StopTask",
          "ecs:TagResource", "ecs:UntagResource", "ecs:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "ApplicationAutoScaling",
        Effect = "Allow",
        Action = [
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:TagResource",
          "application-autoscaling:UntagResource",
          "application-autoscaling:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "ECRManagement",
        Effect = "Allow",
        Action = [
          "ecr:CreateRepository", "ecr:DeleteRepository", "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy", "ecr:PutImageScanningConfiguration",
          "ecr:PutImageTagMutability", "ecr:TagResource", "ecr:UntagResource",
          "ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:PutImage"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "compute_infrastructure_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.compute_infrastructure_policy.arn
} 