variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "a_record_ip" {
  description = "IP address for the A record (e.g., EC2 public IP)"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "route53-dns"
}
