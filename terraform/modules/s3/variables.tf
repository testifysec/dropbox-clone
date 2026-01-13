variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "enable_intelligent_tiering" {
  description = "Enable intelligent tiering for cost optimization"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "Origins allowed for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "allowed_role_arns" {
  description = "IAM role ARNs allowed to access the bucket"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
