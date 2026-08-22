# Provider configuration separated for clarity.
variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

# NOTE: If you want to use a remote backend (S3 + DynamoDB) place config in backend.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # Backend configuration example is placed in backend.tf (commented out by default)
}