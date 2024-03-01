output "alb_application_url" {
  value       = "https://${module.alb.dns_name}"
  description = "Copy this value in your browser in order to access the deployed app"
}

output "fqdn_application_url" {
  value       = var.create_route53_record ? "https://${aws_route53_record.webapp[0].fqdn}" : null
  description = "Public FQDN"
}