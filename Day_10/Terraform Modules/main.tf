# AWS VPC creation
module "aws_vpc" {
  source = "./modules/aws_vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  subnet_cidr = var.subnet_cidr
  subnet_name = var.subnet_name
}

# AWS Security Group creation
module "aws_sg" {
  source = "./modules/aws_sg"
  security_group_name = var.security_group_name
  vpc_id = module.aws_vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

# AWS EC2 instance creation
module "aws_instance" {
  source = "./modules/aws_instance"
  instance_name = var.instance_name
  instance_type = var.instance_type
  ami_id = var.ami_id
}