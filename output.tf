output "alb_zone_id" {
  description = "The zone_id of the ALB"
  value       = aws_lb.this.zone_id
}
