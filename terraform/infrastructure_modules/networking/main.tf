module "vpc" {
  source      = "../../resource_modules/vpc"
  cidr_block  = var.cidr_block
  environment = var.environment
}

