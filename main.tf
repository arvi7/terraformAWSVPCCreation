# A Resource block to develop AWS_VPC
resource "aws_vpc" "webapp_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webapp_vpc_tag"
  }
}

# A Resource block to develop public_subnets with variable public_subnets
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.webapp_vpc.id
  count = length(var.public_subnets)
  cidr_block = element(var.public_subnets,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "Public subnet ${count.index+1} tag"
  }
}

# A Resource block to develop private_subnets with variable private_subnets
resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.webapp_vpc.id
  count = length(var.private_subnets)
  cidr_block = element(var.private_subnets,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "Private subnet ${count.index+1} tag"
  }
}

/* A Resource block for creating Internet Gateway
Internet Gateway: It is like a bridge between our VPC and Internet. 
It controls the Inbound and Outbound traffic of VPC
*/
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.webapp_vpc.id
    tags = {
      Name = "Internet Gateway tag"
    }
}

# A Resource block to create a Route Table
/*
A Route Table contains set of Rules which guides where traffic
flows within the VPC.
*/
resource "aws_route_table" "secondRT" {
  vpc_id = aws_vpc.webapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
  tags = {
    Name = "second RT"
  }
}

# Associating each public subnet with the second Route Table.
resource "aws_route_table_association" "public_subnet_secondRT" {
  count = length(var.public_subnets)
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.secondRT.id
}