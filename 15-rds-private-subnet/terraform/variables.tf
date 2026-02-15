variable "aws_region" { type = string; default = "ap-south-2" }
variable "vpc_cidr" { type = string; default = "10.0.0.0/16" }
variable "public_subnet_cidrs" { type = list(string); default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnet_cidrs" { type = list(string); default = ["10.0.3.0/24", "10.0.4.0/24"] }
variable "availability_zones" { type = list(string); default = ["ap-south-2a", "ap-south-2b"] }

variable "db_identifier" { type = string; default = "myapp-database" }
variable "db_instance_class" { type = string; default = "db.t3.micro" }
variable "db_storage" { type = number; default = 20 }
variable "db_name" { type = string; default = "myappdb" }
variable "db_username" { type = string; sensitive = true }
variable "db_password" { type = string; sensitive = true }
variable "multi_az" { type = bool; default = false }
