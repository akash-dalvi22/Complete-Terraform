
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