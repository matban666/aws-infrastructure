provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# VPC (If you don't have an existing one) 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnet (If you don't have an existing one)
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id 
  cidr_block = "10.0.0.0/24"
}

# Security Group
resource "aws_security_group" "allow_web" {
  vpc_id = aws_vpc.main.id  # Assuming you're using the VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Adjust egress rules as needed 
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-09cce85cf54d36b29"
  instance_type = "t2.micro" 

  subnet_id         = aws_subnet.public.id # If using the created subnet 
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    encrypted   = true 
  }

  tags = {
    Name = "My Web Server" 
  }
}
