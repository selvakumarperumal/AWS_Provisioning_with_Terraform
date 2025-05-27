module "vpc_hyd2a" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnet" {
  source = "../modules/subnet"
  vpc_id = module.vpc_hyd2a.vpc_id
  subnet_cidr = var.subnet_cidr
  availability_zone = var.availability_zone
  
}