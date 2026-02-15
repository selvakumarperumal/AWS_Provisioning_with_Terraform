variable "vpc_a_cidr" {
  description = "CIDR for VPC A (Application)"
  type        = string
}

variable "vpc_b_cidr" {
  description = "CIDR for VPC B (Database)"
  type        = string
}

variable "subnet_a_cidr" {
  description = "Subnet CIDR in VPC A"
  type        = string
}

variable "subnet_b_cidr" {
  description = "Subnet CIDR in VPC B"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}
