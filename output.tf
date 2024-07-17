output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The Zone ID of the ALB"
  value       = module.alb.alb_zone_id
}
