variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
}

variable "a_record_name" {
  description = "Subdomain for the A record (empty string for apex)"
  type        = string
  default     = ""
}

variable "a_record_ip" {
  description = "IPv4 address for the A record"
  type        = string
  default     = ""
}

variable "ttl" {
  description = "TTL for DNS records in seconds"
  type        = number
  default     = 300
}

variable "enable_health_check" {
  description = "Whether to create a health check for the A record"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Path for the HTTP health check"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
