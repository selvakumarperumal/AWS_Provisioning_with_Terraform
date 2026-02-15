output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.main.id
}

output "subnet_name" {
  description = "The name tag of the subnet"
  value       = aws_subnet.main.tags["Name"]
}
