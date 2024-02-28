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
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

## Local
locals {
  name     = "${var.project_name}-${var.env}"
  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}
