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

module "igw" {
  source = "../modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source    = "../modules/route-table"
  vpc_id    = module.vpc.vpc_id
  igw_id    = module.igw.igw_id
  subnet_id = module.subnet.subnet_id
}

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

# SSH Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

module "ec2" {
  source            = "../modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.subnet.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = aws_key_pair.deployer.key_name
}
