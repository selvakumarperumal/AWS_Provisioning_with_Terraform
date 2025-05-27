module "network" {
    source = "../modules/network"
    vpc_cidr = var.vpc_cidr
    subnet_cidrs = var.subnet_cidrs
    availability_zones = var.availability_zones
}

resource "aws_key_pair" "keypair" {
    key_name   = "my-key-pair"
    public_key = file("${var.public_key_path}")
  
}

module "instance" {
    source = "../modules/instance"
    vpc_id = module.network.vpc_id
    subnet_ids = module.network.subnet_ids
    public_key = aws_key_pair.keypair.key_name
    instance_type = var.instance_type
    ami_id = var.ami_id
  
}