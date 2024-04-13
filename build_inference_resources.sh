cd terraform ||exit

terraform apply -target="aws_security_group.MLServiceSecurityGroup" -auto-approve ||exit
terraform apply -target="aws_ecs_cluster.MLServiceCluster" -auto-approve ||exit
terraform apply -target="aws_iam_role.MLInferenceServiceRole" -auto-approve ||exit
terraform apply -target="aws_iam_role_policy_attachment.MLInferenceServiceRolePolicyAttachments" -auto-approve ||exit
terraform apply -target="aws_ecs_task_definition.MLInferenceTaskDefinition" -auto-approve ||exit

cd ..