variable "subnet_cidr_block" {
    description = "subnet IP address range"
    type        = list(string)
  
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  
}