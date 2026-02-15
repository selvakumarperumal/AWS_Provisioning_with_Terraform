module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnet" {
  source              = "../modules/subnet"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "nacl" {
  source             = "../modules/nacl"
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.subnet.public_subnet_id
  private_subnet_id  = module.subnet.private_subnet_id
  public_subnet_cidr = var.public_subnet_cidr
  ssh_cidr           = var.ssh_cidr
}
