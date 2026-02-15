variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "ec2_sg_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "target_group_arn" { type = string }

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}
