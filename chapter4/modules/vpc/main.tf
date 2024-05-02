// modules/vpc/main.tf

resource "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true // ホスト名を有効にする
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.gateway_name
  }
}
