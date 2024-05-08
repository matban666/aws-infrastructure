# The same variable and provider as your main script
variable "SSH_PUBLIC_KEY" {}

provider "aws" {
  region = "eu-west-2" 
}

# Data Sources to Find Existing Resources 
data "aws_instance" "example" {
  tags = {
    Name = "My Web Server"
  }
}

data "aws_key_pair" "my_key_pair" {
  key_name  = "my-ec2-key" 
}

data "aws_security_group" "allow_web" {
  name = "My Security Group" 
}

data "aws_subnet" "public" {
  tags = {
    Name = "My Public Subnet"
  }
}

data "aws_route_table" "public" {
  tags = {
    Name = "My Public Route Table"
  }
}

data "aws_internet_gateway" "gw" {
  tags = {
    Name = "My Internet Gateway"
  }
}

data "aws_vpc" "main" { 
  tags = {
    Name = "My VPC"
  }
}

# Destroy Resources (in approximate reverse order)
resource "null_resource" "destroy" {

  # EC2 Instance
  triggers {
    instance_id = data.aws_instance.example.id 
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed EC2 Instance'"
  } depends_on = [data.aws_instance.example]

  # SSH Key Pair
  triggers {
    key_name = data.aws_key_pair.my_key_pair.key_name
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Key Pair'"
  } depends_on = [data.aws_key_pair.my_key_pair]

  # Security Group
  triggers {
    security_group_id = data.aws_security_group.allow_web.id
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Security Group'"
  } depends_on = [data.aws_security_group.allow_web]

  # Route to Internet Gateway 
  triggers {
    route_table_id = data.aws_route_table.public.id
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Internet Gateway Route'"
  } depends_on = [ data.aws_route_table.public]

  # Subnet Route Table Association
  triggers {
    route_table_association_id = aws_route_table_association.public_route.id 
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Route Table Association'"
  } 

  # Internet Gateway
  triggers {
    internet_gateway_id = data.aws_internet_gateway.gw.id
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Internet Gateway'"
  } depends_on = [data.aws_internet_gateway.gw]

  # Route Table 
  triggers {
    route_table_id = data.aws_route_table.public.id
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Route Table'"
  } depends_on = [data.aws_route_table.public]

  # Subnet
  triggers {
    subnet_id = data.aws_subnet.public.id
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed Subnet'"
  } depends_on = [data.aws_subnet.public]

  # VPC
  triggers {
    vpc_id = data.aws_vpc.main.id
  }
  provisioner "local-exec" {
    command = "echo 'Destroyed VPC'"
  } depends_on = [data.aws_vpc.main]
}