module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "network" {
  source               = "../modules/network"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source             = "../modules/rds"
  private_subnet_ids = module.network.private_subnet_ids
  rds_sg_id          = module.security_group.rds_sg_id
  db_identifier      = var.db_identifier
  db_instance_class  = var.db_instance_class
  db_storage         = var.db_storage
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  multi_az           = var.multi_az
}
