output "rds_endpoint" {
  description = "Connect to RDS from EC2: mysql -h <endpoint> -P 3306 -u admin -p"
  value       = module.rds.rds_endpoint
}

output "rds_address" {
  value = module.rds.rds_address
}

output "connection_command" {
  description = "Run this from an EC2 in the public subnet"
  value       = "mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p ${var.db_name}"
  sensitive   = true
}
