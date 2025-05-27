variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "value of the VPC CIDR block"
  type        = string
  default = "10.0.0.0/16"
}