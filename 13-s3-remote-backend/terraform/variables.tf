variable "aws_region" {
  type    = string
  default = "ap-south-2"
}

variable "bucket_name" {
  description = "Globally unique bucket name"
  type        = string
}

variable "dynamodb_table_name" {
  type    = string
  default = "terraform-state-lock"
}
