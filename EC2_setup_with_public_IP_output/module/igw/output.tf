output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "value of the Internet Gateway ID"
  # The value of the Internet Gateway ID is obtained from the module output
}