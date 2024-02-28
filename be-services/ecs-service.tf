## ECS Service
module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.9.1"

  name               = local.service_name
  desired_count      = 3
  cluster_arn        = data.aws_ecs_cluster.core_infra.arn
  enable_autoscaling = false

  # Task Definition
  enable_execute_command = true

  container_definitions = {
    (local.container_name) = {
      essential                = true
      image                    = local.docker_image_url
      readonly_root_filesystem = false

      health_check = {
        command = ["CMD-SHELL", "curl -f http://localhost:${local.container_port} || exit 1"]
      }

      port_mappings = [
        {
          protocol      = "tcp",
          containerPort = local.container_port
        }
      ]

      environment = [
        {
          name  = "ENVIRONMENT",
          value = var.env
        }
      ]

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${local.service_name}/${local.container_name}"
      cloudwatch_log_group_retention_in_days = 30
      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/${local.service_name}/${local.container_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"

        }
      }
    }
  }

  service_registries = {
    registry_arn = aws_service_discovery_service.this.arn
  }

  subnet_ids = data.aws_subnets.private.ids
  security_group_rules = {
    ingress_all_service = {
      type        = "ingress"
      from_port   = local.container_port
      to_port     = local.container_port
      protocol    = "tcp"
      description = "Service port"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}