variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
  
}

variable "region" {
  description = "AWS region to deploy the VPC"
  type        = string
  default     = "ap-south-2"
  
}

variable "subnet_cidr_block" {
    description = "subnet IP address range"
    type        = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-south-2a", "ap-south-2b", "ap-south-2c"]
  
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t3.micro"
  
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-053a0835435bf4f45" # Example AMI ID, replace with a valid one for your region
  
}

variable "public_key_path" {
  description = "Path to the public key file for SSH access"
  type        = string
  default     = "/home/selvakumar/Documents/.ssh_keys_aws/aws_ec2_access_key.pub"
  
}