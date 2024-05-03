// main.tf

terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

module "key_pair" {
  source = "./modules/key-pair"
  name   = "${local.class_number}-${formatdate("MMDD", timestamp())}"
}

module "vpc" {
  source         = "./modules/network/vpc"
  vpc_name       = "${local.class_number}_vpc"
  vpc_cidr_block = "10.1.0.0/16"
  gateway_name   = "${local.class_number}_gw"
}

module "public_a_subnet" {
  source                  = "./modules/network/subnet"
  vpc_id                  = module.vpc.vpc_id
  name                    = "${local.class_number}_public_a"
  availability_zone       = "us-east-1a"
  cidr_block              = "10.1.10.0/24"
  map_public_ip_on_launch = true
}

module "private_b_subnet" {
  source                  = "./modules/network/subnet"
  vpc_id                  = module.vpc.vpc_id
  name                    = "${local.class_number}_private_a"
  availability_zone       = "us-east-1b"
  cidr_block              = "10.1.11.0/24"
  map_public_ip_on_launch = false
}

module "nat_gw" {
  source           = "./modules/network/nat-gateway"
  eip_name         = "${local.class_number}_eip"
  subnet_id        = module.public_a_subnet.subnet_id
  nat_gateway_name = "${local.class_number}_nat_gw"
}

module "public_route_table" {
  source           = "./modules/network/route-table"
  route_table_name = "${local.class_number}_rt"
  vpc_id           = module.vpc.vpc_id
  gateway_id       = module.vpc.gateway_id
  subnet_id        = module.public_a_subnet.subnet_id
  cidr_block       = "0.0.0.0/0"
}

module "private_route_table" {
  source           = "./modules/network/route-table"
  route_table_name = "${local.class_number}_private_rt"
  vpc_id           = module.vpc.vpc_id
  gateway_id       = module.nat_gw.nat_gateway_id
  subnet_id        = module.private_b_subnet.subnet_id
  cidr_block       = "0.0.0.0/0"
}

module "sg" {
  source      = "./modules/network/security-group"
  name        = "${local.class_number}_sg"
  description = "${local.class_number}_sg"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

module "sg2" {
  source      = "./modules/network/security-group"
  name        = "${local.class_number}_sg2"
  description = "${local.class_number}_sg2"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

module "public_a_ec2" {
  source            = "./modules/ec2"
  name              = "${local.class_number}_public_a"
  ami               = "ami-07caf09b362be10b8" # Amazon Linux 2023
  instance_type     = "t2.micro"
  subnet_id         = module.public_a_subnet.subnet_id
  security_group_id = module.sg.security_group_id
  key_pair_name     = module.key_pair.key_pair_name
  user_data         = <<-EOF
    #! /bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOF
}

module "private_b_ec2" {
  source            = "./modules/ec2"
  name              = "${local.class_number}_private_b"
  ami               = "ami-07caf09b362be10b8" # Amazon Linux 2023
  instance_type     = "t2.micro"
  subnet_id         = module.private_b_subnet.subnet_id
  security_group_id = module.sg2.security_group_id
  key_pair_name     = module.key_pair.key_pair_name
  user_data         = <<-EOF
    #! /bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOF
}
