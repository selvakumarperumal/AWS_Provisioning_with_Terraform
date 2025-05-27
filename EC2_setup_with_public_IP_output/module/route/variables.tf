variable "vpc_id" {
  description = "VPC ID"
  type        = string
  
}

variable "internet_gateway_id" {
    description = "value of the Internet Gateway ID"
    type        = string
}

variable "subnet_ids" {
    description = "List of subnet IDs"
    type        = list(string)
  
}