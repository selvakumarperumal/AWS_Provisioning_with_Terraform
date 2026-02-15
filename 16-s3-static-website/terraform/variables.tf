variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for the website"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "s3-static-website"
}
