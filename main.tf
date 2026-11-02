provider "aws" {
  region = "us-east-1"
}

# 1. CREATE THE VPC (Virtual Private Cloud)
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Production-VPC"
  }
}

# 2. CREATE PUBLIC SUBNETS (For Load Balancers)
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = { Name = "Public-Subnet-1" }
}

# 3. CREATE PRIVATE SUBNETS (For Application Servers)
resource "aws_subnet" "private_app_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "Private-App-Subnet-1" }
}

# 4. CREATE DATABASE SUBNETS (Isolated Backend Tier)
resource "aws_subnet" "private_db_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "Private-DB-Subnet-1" }
}

# 5. INTERNET GATEWAY (Connects Public Subnet to the World)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = { Name = "Main-IGW" }
}

# 6. PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = { Name = "Public-Route-Table" }
}

resource "aws_route_table_association" "pub_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. SECURITY GROUPS (The Firewalls)
# Web Security Group: Only allow HTTP/HTTPS from anyone
resource "aws_security_group" "web_sg" {
  name        = "web-tier-sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Database Security Group: Only allow database traffic FROM the App Security Group
resource "aws_security_group" "db_sg" {
  name        = "db-tier-sg"
  description = "Allow database traffic from app tier only"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id] # Locks down DB access strictly to the web layer
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

