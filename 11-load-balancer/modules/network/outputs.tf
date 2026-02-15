output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
