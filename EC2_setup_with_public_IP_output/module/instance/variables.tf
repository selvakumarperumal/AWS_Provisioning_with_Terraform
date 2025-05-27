variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  
}
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the instance"
  type        = string
  
}

variable "subnet_ids" {
  description = "The subnet IDs to launch the instance in"
  type        = list(string)
  
}

variable "public_key" {
  description = "The public key to use for SSH access"
  type        = string
  sensitive   = true
}

