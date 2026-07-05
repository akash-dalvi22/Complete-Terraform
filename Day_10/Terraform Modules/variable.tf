# Instance Variables
variable "instance_name"{
  type = map(string)
  description = "Name of the instance"
}
variable "instance_type" {
  type = string
  description = "Type of the instance"
}
variable "ami_id" {
  type = string
  description = "AMI ID for the instance"
}

# VPC Variables
variable "vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type = map(string)
}

# Subnet variables
variable "subnet_cidr" {
  type = string
}

variable "subnet_name" {
  type = map(string)
}

# Security Group Variables
variable "security_group_name" {
  type = map(string)
}
