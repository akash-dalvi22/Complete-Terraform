terraform {
  backend "s3" {
    bucket = "nextpath-devops-terraform-state"
    key    = "infrastructure/terraform.tfstate"
    region = "ap-south-1"
  }
}