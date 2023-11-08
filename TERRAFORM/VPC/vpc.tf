
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-3a"
  tags                    = {
    Name = "main_public_subnet"
  }
}

resource "aws_subnet" "main_private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-3b"
  tags = {
    Name = "main_private_subnet"
  }
}


resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "mainGW"
  }
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }
  tags = {
    Name = "mainTableRoute"
  }
}

resource "aws_route_table_association" "main-association" {
  route_table_id = aws_route_table.table.id
  subnet_id = aws_subnet.main_public_subnet.id
}
