variable "region" {
  description = "Region where to release the infrastructure."
  type        = string
  default     = "eu-south-1"
}

variable "project_name" {
  description = "Name of the Project."
  type        = string
  default     = "webapp"
}

variable "env" {
  description = "Environment."
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "The IP range to use for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "domain_name" {
  description = "The Domain name for the project"
  type        = string
  default     = "pierolenzo.it"
}

variable "create_route53_record" {
  description = "Whether to create route53 records or simpli use ALB dns name"
  type        = bool
  default     = false
}

variable "docker_image_url" {
  description = "The docker image"
  type        = string
  default     = "public.ecr.aws/nginx/nginx:mainline"
}