variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "alarm_email" {
  description = "Email address for alarm notifications"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor (optional)"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "cloudwatch-monitoring"
}
