variable "tags" {
  description = "Tags to add with resources created by Terraform"
  type        = map(string)
  default     = {
    Name = "linux-server"
    Environment = var.environment
    Backup = "true"
    CreatedBy = "Terraform"
  }
}
variable "instance_count" {
    description = "Number of instances to create"
    type        = number
}
variable "environment" {
    description = "Environment name"
    type        = string
}

variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "us-east-1"
}