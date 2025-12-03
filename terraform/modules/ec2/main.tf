# find latest Amazon Linux 2 AMI
data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "prog8870-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow SSH from anywhere (for demo)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.al2.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  tags = { Name = "prog8870-ec2" }

  # optional: user_data to install nginx or such
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              EOF
}
