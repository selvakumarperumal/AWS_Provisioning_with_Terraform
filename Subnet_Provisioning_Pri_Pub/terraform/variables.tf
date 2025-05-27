variable "pub_availability_zone" {
  description = "availability zone to use for the public subnet"
  type        = string
  default = "ap-south-2a"
  
}

variable "priv_availability_zone" {
  description = "availability zone to use for the private subnet"
  type        = string
  default = "ap-south-2b"
  
}

variable "vpc_cidr" {
  description = "value of the vpc cidr"
  type        = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR block for the public subnet"
  type        = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "IPv4 CIDR block for the private subnet"
    type        = string
    default = "10.0.2.0/24"
  
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-2"
  
}