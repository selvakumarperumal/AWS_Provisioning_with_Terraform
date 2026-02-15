module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnet" {
  source            = "../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}
