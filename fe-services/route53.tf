data "aws_route53_zone" "primary" {
  count = var.create_route53_record ? 1 : 0

  name         = local.domain_name
  private_zone = false
}

resource "aws_route53_record" "webapp" {
  count = var.create_route53_record ? 1 : 0

  zone_id = data.aws_route53_zone.primary[0].zone_id
  name    = local.fe_domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}