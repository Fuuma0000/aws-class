output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "gateway_id" {
  value = aws_internet_gateway.igw.id
}
