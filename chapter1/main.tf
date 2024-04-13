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
  name   = "ie3b14-0411"
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
}

module "ec2" {
  source            = "./modules/ec2"
  name              = "ie3b14-sv"
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.vpc.security_group_id
  key_pair_name     = module.key_pair.key_pair_name
}

