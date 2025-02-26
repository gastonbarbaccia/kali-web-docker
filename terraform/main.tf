provider "aws" {
  region = "us-east-1"  # Cambia la región si es necesario
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all_tcp"
  description = "Permite todo el tráfico TCP público"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami = "ami-08e5424edfe926b43"  # Ubuntu 22.04 LTS en us-east-1
  instance_type = "t2.medium"
  security_groups = [aws_security_group.allow_all.name]
  user_data = file("userdata.sh")  # Script de inicialización

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}
