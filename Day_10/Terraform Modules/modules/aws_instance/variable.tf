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