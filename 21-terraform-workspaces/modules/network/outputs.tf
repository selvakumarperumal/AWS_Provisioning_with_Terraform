output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.main.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.main.id
}
