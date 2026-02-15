variable "aws_region" {
  description = "AWS region for S3 origin"
  type        = string
  default     = "ap-south-2"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for CDN origin"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "cloudfront-cdn"
}
