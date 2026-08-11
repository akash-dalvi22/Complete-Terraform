# Conditional Expression, Dynamic Block and Splat Expression

resource "aws_instance" "linux-server" {
  ami           = "ami-0c55b159cbfafe1f0"
  count        = var.instance_count
#   instance_type = "t2.micro"
    # This is the demonstration of using a conditional expression to set the instance type based on the "environment" variable.
    instance_type = var.environment == "dev" ? "t2.micro" : "t2.medium"

  tags = var.tags
}

resource "aws_security_group" "linux-server-sg" {
  name        = "linux-server-sg"
  description = "Security group for Linux server"
  vpc_id      = aws_vpc.main.id

  tags = var.tags

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }
}