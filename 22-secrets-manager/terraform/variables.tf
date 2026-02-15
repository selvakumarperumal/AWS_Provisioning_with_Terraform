variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "secrets-manager"
}

variable "db_username" {
  description = "Database username to store in secret"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password to store in secret"
  type        = string
  sensitive   = true
}
