variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "hello-lambda"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "lambda-functions"
}
