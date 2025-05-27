output "subnet_name" {
  value = aws_subnet.main.tags["Name"]
  
} 