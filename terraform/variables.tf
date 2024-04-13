variable "AWS_REGION" {
  description = "The AWS region in which resource are deployed"
  default = "us-east-1"
}

variable "ECR_REPOSITORY_FOR_ML_SERVICES" {
  type = string
  default = "machine-learning-image-repository"
}

variable "SECURITY_GROUP_FOR_ML_SERVICES" {
  type = string
  default = "MLServiceSecurityGroup"
}

variable "pipeline_name" {
  description = "The microservice name whose resources are being deployed"
  default = "ml_inference_pipeline"
}


variable "ECS_CLUSTER_FOR_ML_SERVICES" {
  type = string
  default = "ml_cluster"
}


variable "IAM_ROLE_FOR_INFERENCE_SERVICE" {
  type = string
  default = "MLInferenceServiceRole"
}


variable "TEXT_CLASSIFIER_IMAGE_ARN" {
  type = string
  default = "123456789123.dkr.ecr.us-east-1.amazonaws.com/machine-learning-image-repository:text_classifier_inference_image"
}

variable "ECS_TEXT_CLASSIFICATION_TASK_DEFINITION_NAME" {
  type = string
  default = "MLDisasterTweetClassificationInferenceTaskDefinition"
}

variable "ECS_TEXT_CLASSIFICATION_CONTAINER_NAME" {
  type = string
  default = "MLDisasterTweetClassificationInferenceContainer"
}
