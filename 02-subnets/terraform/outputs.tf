output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.subnet.subnet_id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.subnet.subnet_name
}
