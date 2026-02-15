module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "network" {
  source             = "../modules/network"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.subnet_cidrs
  availability_zones = var.availability_zones
}

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source     = "../modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.network.subnet_ids
  alb_sg_id  = module.security_group.alb_sg_id
}

resource "aws_key_pair" "deployer" {
  key_name   = "alb-demo-key"
  public_key = file(var.public_key_path)
}

module "ec2" {
  source           = "../modules/ec2"
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  subnet_ids       = module.network.subnet_ids
  ec2_sg_id        = module.security_group.ec2_sg_id
  key_name         = aws_key_pair.deployer.key_name
  target_group_arn = module.alb.target_group_arn
}
