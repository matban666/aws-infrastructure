# Variable declaration
variable "SSH_PUBLIC_KEY" {}

provider "aws" {
  region = "eu-west-2"  # Replace with your desired region
}

# VPC (If you don't have an existing one) 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = { 
    Name = "My VPC"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My Public Route Table"
  }
}

# Subnet (If you don't have an existing one)
resource "aws_subnet" "public" {
  vpc_id      = aws_vpc.main.id  
  cidr_block  = "10.0.0.0/24"   
  map_public_ip_on_launch = true # Ensure dynamic public IP assignment

  tags = { 
    Name = "My Public Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My Internet Gateway"
  }
}

# Subnet Route Table Association
resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public.id # Assuming your subnet is named 'public'
  route_table_id = aws_route_table.public.id 
}

# Route to the Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id 
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

# SSH Key
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-ec2-key" 
  public_key = var.SSH_PUBLIC_KEY 
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

  key_name = aws_key_pair.my_key_pair.key_name
}


