variable "vpc_cidr" {
    description = "IPv4 CIDR block for the VPC"
    type        = string
  
}

variable "subnet_cidrs" {
    description = "List of IPv4 CIDR blocks for the subnets"
    type        = list(string)
  
}
variable "availability_zones" {
    description = "List of availability zones for the subnets"
    type        = list(string)
  
}