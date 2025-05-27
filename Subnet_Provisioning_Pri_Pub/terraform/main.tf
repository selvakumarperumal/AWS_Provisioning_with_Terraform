module "vpc_hyd2" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr

}

module "subnet_hyd2" {
  source = "../modules/subnet"
  vpc_id = module.vpc_hyd2.vpc_id
  pub_availability_zone = var.pub_availability_zone
  priv_availability_zone = var.priv_availability_zone
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  
}
