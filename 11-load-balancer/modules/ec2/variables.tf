variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "target_group_arn" {
  description = "Target group ARN to register instances"
  type        = string
}
