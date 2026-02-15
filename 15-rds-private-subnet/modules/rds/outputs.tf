output "rds_endpoint" {
  description = "RDS connection endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  description = "RDS hostname"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "db_name" {
  value = aws_db_instance.mysql.db_name
}
