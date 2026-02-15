variable "aws_region" { type = string; default = "ap-south-2" }
variable "vpc_cidr" { type = string; default = "10.0.0.0/16" }
variable "subnet_cidrs" { type = list(string); default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "availability_zones" { type = list(string); default = ["ap-south-2a", "ap-south-2b"] }
variable "ami_id" { type = string; default = "ami-053a0835435bf4f45" }
variable "instance_type" { type = string; default = "t3.micro" }
variable "public_key_path" { type = string }
variable "min_size" { type = number; default = 1 }
variable "max_size" { type = number; default = 4 }
variable "desired_capacity" { type = number; default = 2 }
