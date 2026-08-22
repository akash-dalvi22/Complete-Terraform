terraform {
  backend "s3" {
    bucket = "provisioners-my-terraform-state-bucket"
    key    = "main/terraform.tfstate"
    region = "us-east-1"
  }
}