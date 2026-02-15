output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.igw.igw_id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.route_table.public_route_table_id
}
