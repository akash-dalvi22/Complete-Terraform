###################################
# EC2 Instance Variables
###################################
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = map(string)
  default = {
    "dev" : "t3.micro",
    "staging" : "t3.small",
    "prod" : "t2.medium"
  }
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}