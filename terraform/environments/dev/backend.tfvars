# Terraform Backend Configuration for Dev
bucket         = "dropbox-clone-terraform-state-dev"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "dropbox-clone-terraform-locks-dev"
