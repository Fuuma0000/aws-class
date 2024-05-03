resource "aws_route_table" "rtb" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
  }
  tags = {
    Name = var.route_table_name
  }
}

// ルートテーブルとサブネットを関連付ける
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.rtb.id
}
