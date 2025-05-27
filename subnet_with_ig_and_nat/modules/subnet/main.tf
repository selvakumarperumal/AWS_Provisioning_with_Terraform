resource "aws_subnet" "public_subnet" {
  vpc_id                 = var.vpc_id
  cidr_block             = var.public_Subnet_CIDR
  availability_zone      = var.public_availability_zone
  map_public_ip_on_launch = true  
}

resource "aws_subnet" "private_subnet" {
  vpc_id                 = var.vpc_id
  cidr_block             = var.private_Subnet_CIDR
  availability_zone      = var.private_availability_zone
  map_public_ip_on_launch = false  
  
}

