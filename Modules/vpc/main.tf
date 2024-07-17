resource "aws_vpc" "my-vpc" {
  cidr_block       = var.cidr_block_value
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_subnet" "Public-sub-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.cidr_block_value_Public-sub-1
  map_public_ip_on_launch = true
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "Public-sub-1"
  }
}

resource "aws_subnet" "Public-sub-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.cidr_block_value_Public-sub-2
  map_public_ip_on_launch = true
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "Public-sub-2"
  }
}

resource "aws_route_table" "Public-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "Public-route-table"
  }
}

resource "aws_route_table_association" "Public-route-association-1" {
  subnet_id      = aws_subnet.Public-sub-1.id
  route_table_id = aws_route_table.Public-route-table.id
}

resource "aws_route_table_association" "Public-route-association-2" {
  subnet_id      = aws_subnet.Public-sub-2.id
  route_table_id = aws_route_table.Public-route-table.id
}

resource "aws_subnet" "Private-sub-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.cidr_block_value_Private-sub-1
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "Private-sub-1"
  }
}

resource "aws_subnet" "Private-sub-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.cidr_block_value_Private-sub-2
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "Private-sub-2"
  }
}

resource "aws_eip" "eip-1-ngw-1" {
  domain   = "vpc"

  tags = {
    Name = "eip-1-ngw-1"
  }
}

resource "aws_eip" "eip-2-ngw-2" {
  domain   = "vpc"

  tags = {
    Name = "eip-2-ngw-2"
  }
}

## Create NAT gateway

resource "aws_nat_gateway" "ngw-A" {
  allocation_id = aws_eip.eip-1-ngw-1.id
  subnet_id     = aws_subnet.Public-sub-1.id

  tags = {
    Name = "ngw-A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my-igw]
}

resource "aws_nat_gateway" "ngw-B" {
  allocation_id = aws_eip.eip-2-ngw-2.id
  subnet_id     = aws_subnet.Public-sub-2.id

  tags = {
    Name = "ngw-B"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my-igw]
}

## Create private route table

resource "aws_route_table" "Private-RT-1" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw-A.id
  }

  tags = {
    Name = "Private-RT-1"
  }
}

resource "aws_route_table_association" "Private-route-association-1" {
  subnet_id      = aws_subnet.Private-sub-1.id
  route_table_id = aws_route_table.Private-RT-1.id
}

resource "aws_route_table" "Private-RT-2" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw-B.id
  }

  tags = {
    Name = "Private-RT-2"
  }
}

resource "aws_route_table_association" "Private-route-association-2" {
  subnet_id      = aws_subnet.Private-sub-2.id
  route_table_id = aws_route_table.Private-RT-2.id
}




