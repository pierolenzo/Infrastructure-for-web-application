## Service Discovery
resource "aws_service_discovery_service" "this" {
  name = local.service_name

  dns_config {
    namespace_id = data.aws_service_discovery_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## TLS Self Signed
resource "tls_private_key" "webapp" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "webapp" {
  private_key_pem = tls_private_key.webapp.private_key_pem

  subject {
    common_name  = local.domain_name
    organization = "Piero Lenzo"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.webapp.private_key_pem
  certificate_body = tls_self_signed_cert.webapp.cert_pem
}

## ALB
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.7.0"

  name     = local.name
  internal = false

  enable_deletion_protection = false

  vpc_id  = data.aws_vpc.vpc.id
  subnets = data.aws_subnets.public.ids
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = { for subnet in data.aws_subnet.private_cidr :
    (subnet.availability_zone) => {
      ip_protocol = "-1"
      cidr_ipv4   = subnet.cidr_block
    }
  }

  listeners = {
    http = {
      port     = "80"
      protocol = "HTTP"

      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.cert.arn

      forward = {
        target_group_key = "ecs-task"
      }
    }

  }

  target_groups = {
    ecs-task = {
      backend_protocol = "HTTP"
      backend_port     = local.container_port
      target_type      = "ip"

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200-299"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # There's nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

}
