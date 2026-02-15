variable "project_name" {
  description = "Project name for naming resources"
  type        = string
}

variable "alarm_email" {
  description = "Email address for alarm notifications"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
  default     = ""
}

variable "cpu_threshold_high" {
  description = "CPU alarm threshold (high)"
  type        = number
  default     = 80
}

variable "cpu_threshold_low" {
  description = "CPU alarm threshold (low)"
  type        = number
  default     = 20
}

variable "evaluation_periods" {
  description = "Number of periods to evaluate"
  type        = number
  default     = 3
}

variable "period" {
  description = "Evaluation period in seconds"
  type        = number
  default     = 60
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
