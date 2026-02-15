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
