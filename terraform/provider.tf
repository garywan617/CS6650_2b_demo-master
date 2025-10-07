# Specify where to find the AWS & Docker providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.7.0"
      
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.0.0"
    }
  }
}

# Configure AWS credentials & region
provider "aws" {
  region     = var.aws_region
  profile = "default"      # 你要用的 AWS profile
  
}

# Fetch an ECR auth token so Terraform's Docker provider can log in
data "aws_ecr_authorization_token" "registry" {}

# Configure Docker provider to authenticate against ECR automatically
provider "docker" {
  # host = "npipe:////./pipe/docker_engine"
  host = "tcp://localhost:2375"
  # registry_auth {
  #   address  = data.aws_ecr_authorization_token.registry.proxy_endpoint
  #   username = data.aws_ecr_authorization_token.registry.user_name
  #   password = data.aws_ecr_authorization_token.registry.password
  # }
}