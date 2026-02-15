output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "asg_name" {
  value = module.asg.asg_name
}
