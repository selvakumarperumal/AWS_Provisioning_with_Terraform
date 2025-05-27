resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
        Name = "IGW"
    }
  
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags = {
        Name = "NAT EIP"
    }   
  
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = var.public_subnet_id

    tags = {
        Name = "NAT Gateway"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}


resource "aws_route_table_association" "public_association" {
    subnet_id      = var.public_subnet_id
    route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_route_table_association" "private_association" {
    subnet_id      = var.private_subnet_id
    route_table_id = aws_route_table.private_rt.id
  
}

