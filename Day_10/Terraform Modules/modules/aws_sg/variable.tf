
# Security Group Variables

variable "security_group_name" {
  type = map(string)
}
variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
