variable "vpc_id" {
  type = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
}
