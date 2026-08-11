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

variable "ingress_rules" {
    description = "List of ingress rules for the security group"
    type        = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default     = [
        {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        },
        {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}