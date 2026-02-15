module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnet" {
  source              = "../modules/subnet"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_az           = var.public_az
  private_az          = var.private_az
}

module "igw" {
  source = "../modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source           = "../modules/route-table"
  vpc_id           = module.vpc.vpc_id
  igw_id           = module.igw.igw_id
  public_subnet_id = module.subnet.public_subnet_id
}
