
resource "aws_vpc" "webapp_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webapp_vpc_tag"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.webapp_vpc.id
  count = length(var.public_subnets)
  cidr_block = element(var.public_subnets,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "Public subnet ${count.index+1} tag"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.webapp_vpc.id
  count = length(var.private_subnets)
  cidr_block = element(var.private_subnets,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "Private subnet ${count.index+1} tag"
  }
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.webapp_vpc.id
    tags = {
      Name = "Internet Gateway tag"
    }
}

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

resource "aws_route_table_association" "public_subnet_secondRT" {
  count = length(var.public_subnets)
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.secondRT.id
}