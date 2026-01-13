# Provider Configuration

provider "aws" {
  region  = var.aws_region
  profile = "testifysec-demo"

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
