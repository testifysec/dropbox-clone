# Dev Environment Configuration - testifysec-demo account

environment = "dev"
aws_region  = "us-east-1"

# VPC
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# EKS - minimal for cost savings
eks_cluster_version     = "1.29"
eks_node_instance_types = ["t3.small"]  # Smaller instances for cost
eks_node_desired_size   = 1             # Single node for dev
eks_node_min_size       = 1
eks_node_max_size       = 2

# RDS - minimal for cost savings
rds_instance_class        = "db.t3.micro"
rds_allocated_storage     = 20
rds_max_allocated_storage = 50
rds_multi_az              = false
rds_deletion_protection   = false

# S3
s3_versioning_enabled = false  # Disable for cost savings in dev

# GitHub Actions
create_github_oidc = true
github_repo        = "testifysec/dropbox-clone"

tags = {
  Environment = "dev"
  Team        = "platform"
  CostCenter  = "demo"
}
