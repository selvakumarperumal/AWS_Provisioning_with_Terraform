variable "public_Subnet_CIDR" {
  description = "CIDR block for the public subnet"
  type        = string
  
}

variable "private_Subnet_CIDR" {
  description = "CIDR block for the private subnet"
  type        = string
  
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  
}

variable "public_availability_zone" {
  description = "The availability zone for the public subnet"
  type        = string
  
}

variable "private_availability_zone" {
  description = "The availability zone for the private subnet"
  type        = string
  
}