variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "vpc_a_cidr" {
  description = "VPC A CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_b_cidr" {
  description = "VPC B CIDR"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_a_cidr" {
  description = "Subnet CIDR in VPC A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "Subnet CIDR in VPC B"
  type        = string
  default     = "10.1.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "ap-south-2a"
}
