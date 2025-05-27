variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "ap-south-2"
  
}

variable "vpc_cidr" {
    description = "IPv4 CIDR block for the VPC"
    type        = string
    default = "10.0.0.0/16"
  
}

variable "public_Subnet_CIDR" {
    description = "IPv4 CIDR block for the public subnet"
    type        = string
    default = "10.0.1.0/24"
  
}

variable "private_Subnet_CIDR" {
    description = "IPv4 CIDR block for the private subnet"
    type        = string
    default = "10.0.2.4/24"
  
}

variable "public_availability_zone" {
    description = "The availability zone for the public subnet"
    type        = string
    default = "ap-south-2a"
  
}

variable "private_availability_zone" {
    description = "The availability zone for the private subnet"
    type        = string
    default = "ap-south-2b"
  
}