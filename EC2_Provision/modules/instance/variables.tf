variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  
}

variable "public_key" {
  description = "The public key to be used for SSH access"
  type        = string
  
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  
}

variable "ami_id" {
  description = "The AMI ID to be used for the EC2 instance"
  type        = string
  
}