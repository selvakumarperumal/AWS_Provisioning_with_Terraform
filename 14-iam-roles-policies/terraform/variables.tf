variable "aws_region" { type = string; default = "ap-south-2" }
variable "vpc_cidr" { type = string; default = "10.0.0.0/16" }
variable "subnet_cidr" { type = string; default = "10.0.1.0/24" }
variable "availability_zone" { type = string; default = "ap-south-2a" }
variable "ami_id" { type = string; default = "ami-053a0835435bf4f45" }
variable "instance_type" { type = string; default = "t3.micro" }
variable "public_key_path" { type = string }
variable "role_name" { type = string; default = "ec2-app-role" }
