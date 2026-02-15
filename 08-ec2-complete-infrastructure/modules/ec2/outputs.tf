output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.web.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.web.private_ip
}
