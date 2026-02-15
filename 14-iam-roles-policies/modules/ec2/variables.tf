variable "vpc_cidr" { type = string }
variable "subnet_cidr" { type = string }
variable "availability_zone" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}
