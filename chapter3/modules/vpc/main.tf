// modules/vpc/main.tf

#----------------------------------------
# VPCの作成
#----------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true // ホスト名を有効にする
}
#----------------------------------------
# パブリックサブネットの作成
#----------------------------------------
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true //public ipを自動で割り当てる
}
#----------------------------------------
# インターネットゲートウェイの作成
#----------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
#----------------------------------------
# ルートテーブルの作成
#----------------------------------------
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
#----------------------------------------
# サブネットにルートテーブルを紐づけ
#----------------------------------------
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}
#----------------------------------------
# セキュリティグループの作成
#----------------------------------------
resource "aws_security_group" "sg" {
  name   = "ie3b0424sg"
  description = "ie3b0424sg"
  vpc_id = aws_vpc.vpc.id
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
