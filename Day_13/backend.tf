terraform {
 backend "s3" {
   bucket = "terraform-state-2024"
   key    = "day_13/terraform.tfstate"
   region = "us-east-1"
   
   
 } 
}