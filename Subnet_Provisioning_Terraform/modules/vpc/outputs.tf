output "vpc_name" {
  value = aws_vpc.main.tags["name"]
}

output "vpc_id" {
  value = aws_vpc.main.id
  
}