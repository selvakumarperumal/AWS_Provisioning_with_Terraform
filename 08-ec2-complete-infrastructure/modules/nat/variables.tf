variable "public_subnet_id" {
  description = "Public subnet ID where NAT Gateway will be placed"
  type        = string
}

variable "igw_id" {
  description = "IGW ID (NAT depends on IGW)"
  type        = string
}
