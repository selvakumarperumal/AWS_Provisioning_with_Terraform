output "workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}

output "vpc_id" {
  description = "VPC ID for this workspace"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR for this workspace"
  value       = module.network.vpc_cidr
}

output "instance_type" {
  description = "Instance type for this workspace"
  value       = local.instance_type
}
