output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.nat.nat_gateway_id
}

output "nat_eip" {
  description = "The Elastic IP of the NAT Gateway"
  value       = module.nat.nat_eip
}
