variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "terraform-workspaces"
}
