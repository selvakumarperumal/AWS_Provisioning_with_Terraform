output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.main.arn
}

output "bucket_name" {
  description = "S3 origin bucket name"
  value       = aws_s3_bucket.origin.id
}

output "bucket_arn" {
  description = "S3 origin bucket ARN"
  value       = aws_s3_bucket.origin.arn
}
