# Main Terraform Configuration - Dropbox Clone

terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    # Backend configuration will be provided via backend config file
    # terraform init -backend-config=environments/dev/backend.tfvars
  }
}

# VPC
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  cluster_name       = "${var.project_name}-${var.environment}"

  tags = local.tags
}

# EKS Cluster
module "eks" {
  source = "./modules/eks"

  cluster_name       = "${var.project_name}-${var.environment}"
  cluster_version    = var.eks_cluster_version
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = var.eks_node_instance_types
  node_desired_size   = var.eks_node_desired_size
  node_min_size       = var.eks_node_min_size
  node_max_size       = var.eks_node_max_size

  tags = local.tags
}

# RDS PostgreSQL
module "rds" {
  source = "./modules/rds"

  identifier              = "${var.project_name}-${var.environment}"
  database_name           = var.database_name
  username                = var.database_username
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  allowed_security_groups = [
    module.eks.cluster_security_group_id,
    module.eks.eks_managed_security_group_id
  ]

  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  multi_az              = var.rds_multi_az
  deletion_protection   = var.rds_deletion_protection

  tags = local.tags
}

# S3 Bucket for file storage
module "s3" {
  source = "./modules/s3"

  bucket_name        = "${var.project_name}-${var.environment}-files-${data.aws_caller_identity.current.account_id}"
  versioning_enabled = var.s3_versioning_enabled
  allowed_role_arns  = [module.iam.app_role_arn]

  tags = local.tags
}

# ECR Repository
module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-api"
  scan_on_push    = true
  max_image_count = 30

  tags = local.tags
}

# IAM Roles for IRSA and GitHub Actions
module "iam" {
  source = "./modules/iam"

  name_prefix          = "${var.project_name}-${var.environment}"
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_provider_url    = module.eks.oidc_provider_url
  namespace            = var.kubernetes_namespace
  service_account_name = var.kubernetes_service_account

  s3_bucket_arn  = module.s3.bucket_arn
  rds_secret_arn = module.rds.secret_arn

  create_github_oidc = var.create_github_oidc
  github_repo        = var.github_repo
  ecr_repository_arn = module.ecr.repository_arn
  eks_cluster_arn    = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks.cluster_name}"

  tags = local.tags
}

# EKS Access Entry for GitHub Actions
# This grants the GitHub Actions role access to the EKS cluster
resource "aws_eks_access_entry" "github_actions" {
  count = var.create_github_oidc ? 1 : 0

  cluster_name  = module.eks.cluster_name
  principal_arn = module.iam.github_actions_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_actions" {
  count = var.create_github_oidc ? 1 : 0

  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = module.iam.github_actions_role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.github_actions]
}

# Data sources
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Local values
locals {
  tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}
