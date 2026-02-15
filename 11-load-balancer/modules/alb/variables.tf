variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ALB (min 2 AZs)"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for ALB"
  type        = string
}
