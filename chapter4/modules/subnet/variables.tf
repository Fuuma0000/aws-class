variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the security group"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the security group"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether to map public IP on launch"
  type        = bool
}

variable "name" {
  description = "The name of the security group"
  type        = string
}
