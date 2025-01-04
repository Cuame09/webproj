# Configure the AWS Provider

provider "aws" {
  region = "eu-west-2"
}

# Create a VPC

resource "aws_vpc" "WEB-PROJ-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "3TWEB-PROJ-vpc"
  }
}


# Create Public subnets

resource "aws_subnet" "public-sub1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.WEB-PROJ-vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Pub-sub1"
  }
}

resource "aws_subnet" "public-sub2" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.WEB-PROJ-vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "Pub-sub2"
  }
}

# Create Private subnets

resource "aws_subnet" "private-sub1" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.WEB-PROJ-vpc.id
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private-sub1"
  }
}

resource "aws_subnet" "private-sub2" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.WEB-PROJ-vpc.id
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private-sub2"
  }
}

resource "aws_subnet" "private-sub3" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.WEB-PROJ-vpc.id
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private-sub3"
  }
}

resource "aws_subnet" "private-sub4" {
  cidr_block        = "10.0.5.0/24"
  vpc_id            = aws_vpc.WEB-PROJ-vpc.id
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private-sub4"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.WEB-PROJ-vpc.id
}



# Public Route Table

resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.WEB-PROJ-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

# CREATE ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-sub1.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public-sub2.id
  route_table_id = aws_route_table.public-RT.id
}


# Nat Gateway

resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "NG" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-sub1.id


  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.IG]
}


# Private Route Tables

resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.WEB-PROJ-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NG.id
  }
}


# CREATE ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.private-sub1.id
  route_table_id = aws_route_table.private-RT.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private-sub2.id
  route_table_id = aws_route_table.private-RT.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.private-sub3.id
  route_table_id = aws_route_table.private-RT.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.private-sub4.id
  route_table_id = aws_route_table.private-RT.id
}