variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "IPv4 CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}
