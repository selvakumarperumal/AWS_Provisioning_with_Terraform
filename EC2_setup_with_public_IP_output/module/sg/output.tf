output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.allow_ssh.id
  # The value of the security group ID is obtained from the module output
  
}