cd terraform || exit 1
terraform apply -target="aws_ecr_repository.ecr_repository" -auto-approve || exit 1
cd ..

source ./config.sh

# Login to AWS
aws ecr get-login-password\
  --region ${REGION} | docker login \
  --username AWS \
  --password-stdin \
  ${IAM_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com || exit

# cd into the inference pipeline folder
cd inference_pipeline || exit

## Build docker image
docker build -t text_classifier_inference_image . || exit
echo "Docker build step completed"

# Variables
ECR_REGISTRY_NAME="machine-learning-image-repository"
ECR_REGISTRY=${IAM_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REGISTRY_NAME}

# Docker tag
IMAGE_NAME="text_classifier_inference_image"
IMAGE_TAG="latest"
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}:${IMAGE_NAME} ||exit

# Docker push
docker push ${ECR_REGISTRY}:${IMAGE_NAME}
echo "Docker push step completed"

cd ../.. || exit