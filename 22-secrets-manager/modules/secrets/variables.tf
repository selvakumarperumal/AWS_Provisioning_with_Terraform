variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
  default     = "Managed by Terraform"
}

variable "secret_value" {
  description = "Secret value as a JSON string"
  type        = string
  sensitive   = true
}

variable "recovery_window_in_days" {
  description = "Number of days to wait before permanent deletion (0 for immediate)"
  type        = number
  default     = 7
}

variable "enable_kms" {
  description = "Use a custom KMS key for encryption"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
