variable "bucket_name" {
  description = "Globally unique S3 bucket name for state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "terraform-state-lock"
}
