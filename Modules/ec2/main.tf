resource "aws_instance" "web-server-1" {
  ami                     = var.ami-id-value
  instance_type           = var.instance_type_value
  vpc_security_group_ids = [ aws_security_group.my-SG.id ]
  subnet_id = var.pri-sub-1-id
  key_name = aws_key_pair.ghost.key_name

  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "web-server-2" {
  ami                     = var.ami-id-value
  instance_type           = var.instance_type_value
  vpc_security_group_ids = [ aws_security_group.my-SG.id ]
  subnet_id = var.pri-sub-2-id
  key_name = aws_key_pair.ghost.key_name

  tags = {
    Name = "web-server-2"
  }
}

resource "aws_instance" "jump-server" {
  ami                     = var.ami-id-value
  instance_type           = var.instance_type_value
  vpc_security_group_ids = [ aws_security_group.my-SG.id ]
  subnet_id = var.pub-sub-1-id
  key_name = aws_key_pair.ghost.key_name

  tags = {
    Name = "jump-server"
  }
}

# Create security group

resource "aws_security_group" "my-SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id-value

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_value]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_value]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-SG"
  }
}

resource "aws_key_pair" "ghost" {
  key_name   = "ghost-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
