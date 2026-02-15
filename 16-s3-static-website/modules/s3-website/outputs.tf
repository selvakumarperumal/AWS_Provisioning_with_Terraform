output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.website.arn
}

output "website_endpoint" {
  description = "The website endpoint URL"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_domain" {
  description = "The domain of the website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_domain
}
