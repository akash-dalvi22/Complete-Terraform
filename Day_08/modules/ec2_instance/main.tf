resource "aws_instance" "terraform_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

}