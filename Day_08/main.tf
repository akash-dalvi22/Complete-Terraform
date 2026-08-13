module "ec2_instance" {
  source        = "./modules/ec2_instance"
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  ami_id        = var.ami_id
}