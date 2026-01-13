variable "name_prefix" {
  description = "Prefix for IAM resource names"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC provider"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "dropbox-clone"
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account"
  type        = string
  default     = "dropbox-clone-api"
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for file storage"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret for RDS credentials"
  type        = string
}

variable "create_github_oidc" {
  description = "Create GitHub Actions OIDC provider and role"
  type        = bool
  default     = true
}

variable "github_repo" {
  description = "GitHub repository in format owner/repo"
  type        = string
  default     = ""
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  type        = string
  default     = ""
}

variable "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
