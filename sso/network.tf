###################################################
## Internet VPC
###################################################
resource "aws_vpc" "sso_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    "Name" = "sso_vpc"
  }
}

###################################################
## Public Subnets
###################################################
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.sso_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.sso_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
}

###################################################
## Private Subnets
###################################################
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.sso_vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.sso_vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"
}

###################################################
## Internet Gateway
###################################################
resource "aws_internet_gateway" "sso_igw" {
  vpc_id = aws_vpc.sso_vpc.id
}

###################################################
## Route Table
###################################################
resource "aws_route_table" "sso_route" {
  vpc_id = aws_vpc.sso_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sso_igw.id
  }
}

###################################################
## Route Table Association
###################################################
resource "aws_route_table_association" "route_public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.sso_route.id
}

resource "aws_route_table_association" "route_public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.sso_route.id
}


$adminConfig=(.\New-AdfsDkmContainer.ps1 -ServiceAccount sixninex\adfssvc -AdfsAdministratorAccount sixninex\Admin)