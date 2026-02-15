# ──────────────────────────────────────────────
# VPC
# ──────────────────────────────────────────────
module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

# ──────────────────────────────────────────────
# Subnets (2 public + 2 private)
# ──────────────────────────────────────────────
module "subnet" {
  source               = "../modules/subnet"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ──────────────────────────────────────────────
# Internet Gateway
# ──────────────────────────────────────────────
module "igw" {
  source = "../modules/igw"
  vpc_id = module.vpc.vpc_id
}

# ──────────────────────────────────────────────
# NAT Gateway (in first public subnet)
# ──────────────────────────────────────────────
module "nat" {
  source           = "../modules/nat"
  public_subnet_id = module.subnet.public_subnet_ids[0]
  igw_id           = module.igw.igw_id
}

# ──────────────────────────────────────────────
# Route Tables
# ──────────────────────────────────────────────
module "route_table" {
  source             = "../modules/route-table"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.igw.igw_id
  nat_gateway_id     = module.nat.nat_gateway_id
  public_subnet_ids  = module.subnet.public_subnet_ids
  private_subnet_ids = module.subnet.private_subnet_ids
}

# ──────────────────────────────────────────────
# Security Group
# ──────────────────────────────────────────────
module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

# ──────────────────────────────────────────────
# SSH Key Pair
# ──────────────────────────────────────────────
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

# ──────────────────────────────────────────────
# EC2 Instance (in first public subnet)
# ──────────────────────────────────────────────
module "ec2" {
  source            = "../modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.subnet.public_subnet_ids[0]
  security_group_id = module.security_group.security_group_id
  key_name          = aws_key_pair.deployer.key_name
}
