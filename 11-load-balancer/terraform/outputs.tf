output "alb_dns_name" {
  description = "Access your app at this URL"
  value       = "http://${module.alb.alb_dns_name}"
}

output "instance_public_ips" {
  value = module.ec2.public_ips
}
