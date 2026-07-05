# Get the list of available availability zones in the current region
data "aws_availability_zones" "available" {
  state = "available"
}
#  AWS VPC creation
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr

  tags = var.vpc_name
}
# AWS Subnet creation
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = var.subnet_name
}
