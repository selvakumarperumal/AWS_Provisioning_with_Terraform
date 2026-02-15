variable "bucket_name" {
  description = "Name of the S3 origin bucket"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "default_ttl" {
  description = "Default cache TTL in seconds"
  type        = number
  default     = 86400
}

variable "max_ttl" {
  description = "Maximum cache TTL in seconds"
  type        = number
  default     = 604800
}

variable "geo_restriction_type" {
  description = "Geo restriction type: none, whitelist, or blacklist"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "List of country codes for geo restriction"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
