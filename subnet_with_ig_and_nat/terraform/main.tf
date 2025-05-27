module "vpc_hyd2" {
    source = "../modules/vpc"
    vpc_cidr = var.vpc_cidr
  
}

module "subnet_hyd2" {
    source = "../modules/subnet"
    vpc_id = module.vpc_hyd2.vpc_id
    public_Subnet_CIDR = var.public_Subnet_CIDR
    private_Subnet_CIDR = var.private_Subnet_CIDR
    public_availability_zone = var.public_availability_zone
    private_availability_zone = var.private_availability_zone
    
}

module "network_hyd2" {
    source = "../modules/network"
    vpc_id = module.vpc_hyd2.vpc_id
    public_subnet_id = module.subnet_hyd2.public_subnet_id
    private_subnet_id = module.subnet_hyd2.private_subnet_id
  
}