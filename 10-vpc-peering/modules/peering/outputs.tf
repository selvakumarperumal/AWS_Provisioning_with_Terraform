output "peering_connection_id" {
  description = "VPC peering connection ID"
  value       = aws_vpc_peering_connection.peer.id
}

output "vpc_a_id" {
  description = "VPC A ID"
  value       = aws_vpc.vpc_a.id
}

output "vpc_b_id" {
  description = "VPC B ID"
  value       = aws_vpc.vpc_b.id
}

output "peering_status" {
  description = "Peering connection status"
  value       = aws_vpc_peering_connection.peer.accept_status
}
