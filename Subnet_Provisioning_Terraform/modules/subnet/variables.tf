variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created."
  type        = string
}

variable "subnet_cidr" {
  description = "A list of CIDR blocks for the subnets."
  type        = string
  
}

variable "availability_zone" {
  description = "Availability zone to create the subnets in."
  type        = string
}