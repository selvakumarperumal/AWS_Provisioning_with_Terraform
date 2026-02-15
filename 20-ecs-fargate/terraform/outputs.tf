output "alb_dns_name" {
  description = "ALB DNS name — access the app here"
  value       = "http://${aws_lb.main.dns_name}"
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}
