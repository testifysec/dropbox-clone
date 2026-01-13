# Terraform Backend Configuration for Dev - testifysec-demo account
bucket         = "testifysec-demo-terraform-state"
key            = "dropbox-clone/dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "testifysec-demo-terraform-locks"
profile        = "testifysec-demo"
