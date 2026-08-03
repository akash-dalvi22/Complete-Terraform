resource "aws_instance" "linux-server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = var.tags
}

resource "aws_s3_bucket" "linux-server-bucket" {
  bucket = "linux-server-bucket-${var.environment}"

  tags = var.tags
}