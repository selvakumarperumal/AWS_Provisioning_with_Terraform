variable "public_subnet_id" {
  description = "The ID of the public subnet where NAT Gateway will be placed"
  type        = string
}

variable "igw_id" {
  description = "The ID of the Internet Gateway (NAT depends on IGW)"
  type        = string
}
