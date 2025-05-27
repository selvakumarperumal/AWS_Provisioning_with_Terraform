variable "pub_availability_zone" {
  description = "availability zone to use for the public subnet"
  type        = string
  
}

variable "priv_availability_zone" {
  description = "availability zone to use for the private subnet"
  type        = string
  
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  
}