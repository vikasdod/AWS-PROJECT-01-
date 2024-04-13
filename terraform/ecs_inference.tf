provider "aws" {
  region = var.AWS_REGION
}


resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.ECR_REPOSITORY_FOR_ML_SERVICES
  image_tag_mutability = "MUTABLE"
  force_delete = true
}


data "aws_vpc" "AWSDefaultVPC" {
  default = true
}


resource "aws_security_group" "MLServiceSecurityGroup" {
  name = var.SECURITY_GROUP_FOR_ML_SERVICES
  vpc_id = data.aws_vpc.AWSDefaultVPC.id
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.SECURITY_GROUP_FOR_ML_SERVICES
  }
}


resource "aws_ecs_cluster" "MLServiceCluster" {
  name = var.ECS_CLUSTER_FOR_ML_SERVICES
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}


resource "aws_iam_role" "MLInferenceServiceRole" {
  name = var.IAM_ROLE_FOR_INFERENCE_SERVICE
  description = "Allows ECS and ECS tasks to call services"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          "Service" : "ecs.amazonaws.com"
        }
        Effect = "Allow"
      },
      {
        Action = "sts:AssumeRole"
        Principal = {
          "Service" : "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "MLInferenceServiceRolePolicyAttachments" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])
  role = aws_iam_role.MLInferenceServiceRole.name
  policy_arn = each.value
}


resource "aws_ecs_task_definition" "MLInferenceTaskDefinition" {
  family = var.ECS_TEXT_CLASSIFICATION_TASK_DEFINITION_NAME
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 4096
  memory = 16384
  task_role_arn = aws_iam_role.MLInferenceServiceRole.arn
  execution_role_arn = aws_iam_role.MLInferenceServiceRole.arn
  container_definitions = jsonencode([
    {
      name = "MLDisasterTweetClassificationInferenceContainer"
      image = var.TEXT_CLASSIFIER_IMAGE_ARN
      cpu = 4096
      memory = 16384
      portMappings = [
        {
          containerPort = 5000
          hostPort = 5000
          protocol = "tcp"
          appProtocol = "http"
        }
      ]
    }
  ])
}
