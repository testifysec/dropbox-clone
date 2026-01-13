variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "dropbox-clone"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EKS Configuration
variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.29"
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 4
}

# RDS Configuration
variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "dropbox"
}

variable "database_username" {
  description = "Master username for RDS"
  type        = string
  default     = "dropbox"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum allocated storage in GB"
  type        = number
  default     = 100
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

# S3 Configuration
variable "s3_versioning_enabled" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

# Kubernetes Configuration
variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "dropbox-clone"
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account name"
  type        = string
  default     = "dropbox-clone-api"
}

# GitHub Actions Configuration
variable "create_github_oidc" {
  description = "Create GitHub Actions OIDC provider"
  type        = bool
  default     = true
}

variable "github_repo" {
  description = "GitHub repository in format owner/repo"
  type        = string
  default     = "testifysec/dropbox-clone"
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
