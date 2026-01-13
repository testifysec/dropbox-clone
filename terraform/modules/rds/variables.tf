variable "identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of subnets for the DB subnet group"
  type        = list(string)
}

variable "allowed_security_groups" {
  description = "Security group IDs allowed to connect to RDS"
  type        = list(string)
}

variable "instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB for autoscaling"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
