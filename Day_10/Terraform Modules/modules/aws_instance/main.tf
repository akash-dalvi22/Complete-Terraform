# AWS EC2 instance creation
resource "aws_instance" "webserver" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = var.instance_name
}