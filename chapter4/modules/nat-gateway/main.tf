resource "aws_eip" "eip" {
  tags = {
    Name = var.eip_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.nat_gateway_name
  }
}
