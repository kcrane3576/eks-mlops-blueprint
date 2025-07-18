provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source      = "../../infrastructure_modules/networking"
  cidr_block  = var.cidr_block
  environment = var.environment
}