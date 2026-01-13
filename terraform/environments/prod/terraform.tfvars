# Prod Environment Configuration

environment = "prod"
aws_region  = "us-east-1"

# VPC - 3 AZs for HA
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# EKS - larger for prod
eks_cluster_version     = "1.29"
eks_node_instance_types = ["t3.large"]
eks_node_desired_size   = 3
eks_node_min_size       = 2
eks_node_max_size       = 10

# RDS - larger instance with HA for prod
rds_instance_class        = "db.t3.small"
rds_allocated_storage     = 50
rds_max_allocated_storage = 200
rds_multi_az              = true
rds_deletion_protection   = true

# S3
s3_versioning_enabled = true

# GitHub Actions
create_github_oidc = true
github_repo        = "testifysec/dropbox-clone"

tags = {
  Environment = "prod"
  Team        = "platform"
}
