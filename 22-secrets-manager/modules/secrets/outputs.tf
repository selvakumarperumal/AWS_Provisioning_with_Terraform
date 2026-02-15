output "secret_arn" {
  description = "ARN of the secret"
  value       = aws_secretsmanager_secret.main.arn
}

output "secret_name" {
  description = "Name of the secret"
  value       = aws_secretsmanager_secret.main.name
}

output "secret_id" {
  description = "ID of the secret"
  value       = aws_secretsmanager_secret.main.id
}

output "kms_key_arn" {
  description = "KMS key ARN (if enabled)"
  value       = var.enable_kms ? aws_kms_key.secret[0].arn : null
}

output "reader_policy_arn" {
  description = "IAM policy ARN for reading this secret"
  value       = aws_iam_policy.reader.arn
}
