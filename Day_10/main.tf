data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet"]
  }
  vpc_id = data.aws_vpc.selected.id
}

data "aws_ami" "ami" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-[0-9]{3}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ami.id
  subnet_id     = data.aws_subnet.selected.id
  instance_type = "t2.micro"

  tags = var.tags
  
}