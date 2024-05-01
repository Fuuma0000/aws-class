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
  name   = "${local.class_number}-${formatdate("YYYYMMDD", timestamp())}"
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_name       = "${local.class_number}_vpc"
  vpc_cidr_block = "10.1.0.0/16"
  subnet_info = {
    public_a = {
      name                    = "${local.class_number}_public_a"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.1.10.0/24"
      map_public_ip_on_launch = true
    },
    private_a = {
      name                    = "${local.class_number}_private_a"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.1.11.0/24"
      map_public_ip_on_launch = false
    },
  }
  gateway_name     = "${local.class_number}_gw"
  route_table_name = "${local.class_number}_rt"
  sg_name          = "${local.class_number}_sg"
  sg_description   = "${local.class_number}_sg"
}

module "ec2" {
  source            = "./modules/ec2"
  name              = "${local.class_number}_public_a"
  ami               = "ami-07caf09b362be10b8" # Amazon Linux 2023
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.vpc.security_group_id
  key_pair_name     = module.key_pair.key_pair_name
}

