# Wire together four focused modules: network, ecr, logging, ecs.

module "network" {
  source         = "./modules/network"
  service_name   = var.service_name
  container_port = var.container_port
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.ecr_repository_name
}

module "logging" {
  source            = "./modules/logging"
  service_name      = var.service_name
  retention_in_days = var.log_retention_days
}

# Reuse an existing IAM role for ECS tasks
data "aws_iam_role" "task_role" {
  name = "cs6650-hw4-task-role"
}

# Reuse an existing IAM role for ECS tasks
data "aws_iam_role" "task_exec_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_caller_identity" "current" {}
output "account_id" { value = data.aws_caller_identity.current.account_id }


module "ecs" {
  source             = "./modules/ecs"
  service_name       = var.service_name
  image              = "${module.ecr.repository_url}:latest"
  container_port     = var.container_port
  subnet_ids         = module.network.subnet_ids
  security_group_ids = [module.network.security_group_id]
  execution_role_arn = data.aws_iam_role.task_exec_role.arn
  task_role_arn      = data.aws_iam_role.task_role.arn
  log_group_name     = module.logging.log_group_name
  ecs_count          = var.ecs_count
  region             = var.aws_region
}


// Build & push the Go app image into ECR
# resource "docker_image" "app" {
#   # Use the URL from the ecr module, and tag it "latest"
#   name = "${module.ecr.repository_url}:latest"

#   build {
#     # relative path from terraform/ → src/
#     context = "C:/Users/wanwa/Desktop/CS6650/CS6650/HW5/part3/CS6650_2b_demo-master/CS6650_2b_demo-master/src"
#     dockerfile = "C:/Users/wanwa/Desktop/CS6650/CS6650/HW5/part3/CS6650_2b_demo-master/CS6650_2b_demo-master/src/Dockerfile"
#     no_cache   = true
#     # Dockerfile defaults to "Dockerfile" in that context
#   }
# }

# resource "docker_registry_image" "app" {
#   # this will push :latest → ECR
#   name = docker_image.app.name
# }


# resource "docker_image" "hello" {
#   name = "hello-world:latest"
# }