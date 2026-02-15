module "peering" {
  source            = "../modules/peering"
  vpc_a_cidr        = var.vpc_a_cidr
  vpc_b_cidr        = var.vpc_b_cidr
  subnet_a_cidr     = var.subnet_a_cidr
  subnet_b_cidr     = var.subnet_b_cidr
  availability_zone = var.availability_zone
}
