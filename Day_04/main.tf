# Folder restructure for Terraform project

resource "aws_instance" "linux-server" {
  ami           = "ami-0c55b159cbfafe1f0"
  count        = var.instance_count
  instance_type = "t2.micro"

  tags = var.tags
}