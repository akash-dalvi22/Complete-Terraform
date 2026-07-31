resource "aws_instance" "linux-server" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"

  tags = {
    Name = "linux-server"
    Environment = "dev"
    Backup = "true"
  }
}