output "secret_arn" {
  description = "ARN of the database credentials secret"
  value       = module.db_secret.secret_arn
}

output "secret_name" {
  description = "Name of the secret"
  value       = module.db_secret.secret_name
}

output "kms_key_arn" {
  description = "KMS key ARN used for encryption"
  value       = module.db_secret.kms_key_arn
}

output "reader_policy_arn" {
  description = "Attach this policy to IAM roles that need to read the secret"
  value       = module.db_secret.reader_policy_arn
}
