terraform {

  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.38"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }
}

## Data
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${local.name}-public-*"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${local.name}-private-*"]
  }
}

data "aws_subnet" "private_cidr" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_ecs_cluster" "core_infra" {
  cluster_name = "${var.project_name}-${var.env}"
}

data "aws_service_discovery_dns_namespace" "this" {
  name = "default.${data.aws_ecs_cluster.core_infra.cluster_name}.local"
  type = "DNS_PRIVATE"
}

## Local
locals {
  name = "${var.project_name}-${var.env}"


  docker_image_url = "public.ecr.aws/nginx/nginx:mainline"
  service_name     = "${var.project_name}-fe-${var.env}"
  container_port   = 80 # Container port is specific to this app example
  container_name   = "${var.project_name}-ecs-fe-${var.env}"

  backend_url = "http://ecsdemo-backend.default.core-infra.local:${local.container_port}"

}
