// modules/vpc/main.tf

resource "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true // ホスト名を有効にする
}

resource "aws_subnet" "subnet" {
  for_each = var.subnet_info

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_info[each.key].cidr_block
  availability_zone       = var.subnet_info[each.key].availability_zone
  map_public_ip_on_launch = var.subnet_info[each.key].map_public_ip_on_launch

  tags = {
    Name = var.subnet_info[each.key].name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.gateway_name
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.subnet["public_a"].id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.vpc.id
  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ALL Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
