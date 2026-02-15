output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_website.bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_website.bucket_arn
}

output "website_url" {
  description = "URL of the static website"
  value       = "http://${module.s3_website.website_endpoint}"
}
