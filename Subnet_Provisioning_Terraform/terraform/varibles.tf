variable "vpc_cidr" {
  description = "IPV4 value of the VPC CIDR block"
  type        = string  
}

variable "subnet_cidr" {
  description = "IPV4 CIDR blocks for the subnets."
  type        = string
  
}

variable "availability_zone" {
  description = "Availability zone to create the subnets in."
  type        = string
  
}

