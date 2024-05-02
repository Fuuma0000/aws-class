variable "route_table_name" {
  description = "The name of the route table"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "gateway_id" {
  description = "The ID of the internet gateway"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the route"
  type        = string
}
