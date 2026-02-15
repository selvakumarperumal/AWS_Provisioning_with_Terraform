output "peering_connection_id" {
  description = "VPC peering connection ID"
  value       = module.peering.peering_connection_id
}

output "peering_status" {
  description = "Peering status"
  value       = module.peering.peering_status
}

output "vpc_a_id" {
  value = module.peering.vpc_a_id
}

output "vpc_b_id" {
  value = module.peering.vpc_b_id
}
