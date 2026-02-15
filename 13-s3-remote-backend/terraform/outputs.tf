output "bucket_name" {
  value = module.backend.bucket_name
}

output "dynamodb_table_name" {
  value = module.backend.dynamodb_table_name
}

output "backend_config" {
  description = "Backend config snippet for other projects"
  value       = module.backend.backend_config
}
