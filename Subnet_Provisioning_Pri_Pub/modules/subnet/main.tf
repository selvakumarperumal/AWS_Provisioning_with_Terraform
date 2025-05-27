resource "aws_subnet" "public_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.pub_availability_zone

  tags = {
    Name = "${var.public_subnet_cidr}-public-subnet"
  }
  
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.priv_availability_zone

  tags = {
    Name = "${var.private_subnet_cidr}-private-subnet"
  }
  
}