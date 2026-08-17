terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" //  --> AWS provider version constraint
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"   //  --> Random provider version constraint
    }
  }
  required_version = ">= 1.3.0" //  --> Terraform version constraint
}

# Provider configuration
provider "aws" {
  region = "us-east-1"
}