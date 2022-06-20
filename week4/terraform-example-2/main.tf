provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.1.7"
  backend "s3" {
    bucket = "devops-masterclass"
    key    = "terraformstate/terraform.tfstate"
    region = "eu-west-2"
  }
}


module "networking" {
    source = "./modules/networking"
    vpc_cidr = var.outer_var_vpc_cidr
}

