# Terraform Backend Configuration for Prod
bucket         = "dropbox-clone-terraform-state-prod"
key            = "prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "dropbox-clone-terraform-locks-prod"
