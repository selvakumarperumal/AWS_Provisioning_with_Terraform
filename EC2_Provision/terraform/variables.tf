variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
  
}

variable "subnet_cidrs" {
    description = "IPV4 CIDR blocks for the subnets"
    type        = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24" ]
  
}

variable "availability_zones" {
    description = "List of availability zones for the subnets"
    type        = list(string)
    default = [ "ap-south-2a", "ap-south-2a", "ap-south-2b", "ap-south-2b" ]
  
}

variable "ami_id" {
  description = "The AMI ID to be used for the EC2 instance"
  type        = string
  default     = "ami-0d75a40cb78759773" # Example AMI ID, replace with a valid one
  
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro" # Example instance type, replace with a valid one
  
}

variable "public_key_path" {
  description = "The public key to be used for SSH access"
  type        = string  
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-2" # Example region, replace with a valid one
  
}