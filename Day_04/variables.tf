#########################
# General Variables
#########################

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type = string
}

#########################
# Tags
#########################
variable "tags" {
  description = "Tags for the created resources"
  type = map(string)
  default = {
    Name = "linux-server"
    Environment = var.environment
    Backup = "true"
    CreatedBy = "Terraform"
  }
}

##########################
# EC2 Variables
##########################

variable "instance_type" {
    description = "Type of EC2 instance"
    type        = string
    default     = "t2.micro"
}

variable "ami_id" {
    description = "Number of instances to create"
    type        = string
    default     = "ami-0c55b159cbfafe1f0"
}