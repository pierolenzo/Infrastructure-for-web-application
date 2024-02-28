## ECS Cluster
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.9.1"

  cluster_name = local.name

  cluster_service_connect_defaults = {
    namespace = aws_service_discovery_private_dns_namespace.this.arn
  }

  fargate_capacity_providers = {
    FARGATE = {}
  }

}