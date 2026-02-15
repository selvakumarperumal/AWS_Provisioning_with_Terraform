output "bucket_name" {
  description = "S3 bucket name (use in backend config)"
  value       = aws_s3_bucket.state.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.state.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name (use in backend config)"
  value       = aws_dynamodb_table.lock.name
}

output "backend_config" {
  description = "Copy this into your other projects' providers.tf"
  value       = <<-EOT

    # Add to providers.tf in other projects:
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.state.id}"
        key            = "PROJECT_NAME/terraform.tfstate"
        region         = "ap-south-2"
        dynamodb_table = "${aws_dynamodb_table.lock.name}"
        encrypt        = true
      }
    }
  EOT
}
