output "cdn_url" {
  description = "CloudFront distribution URL"
  value       = "https://${module.cloudfront.distribution_domain_name}"
}

output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "origin_bucket" {
  description = "S3 origin bucket name"
  value       = module.cloudfront.bucket_name
}
