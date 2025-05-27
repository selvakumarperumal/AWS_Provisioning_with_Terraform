# VPC resources
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
  
}

# Subnet resources
resource "aws_subnet" "subnets" {
    count = length(var.subnet_cidrs)
    
    vpc_id            = aws_vpc.main_vpc.id
    cidr_block        = var.subnet_cidrs[count.index]
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = count.index < 2 ? true : false
    
    tags = {
        Name = "subnet-${count.index + 1}"
    }
  
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw.id
    }
  
}

#Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_association" {
    count = 2
    
    subnet_id      = aws_subnet.subnets[count.index].id
    route_table_id = aws_route_table.public_route_table.id
  
}
# #NAT Gateway
# resource "aws_eip" "nat_eip" {
#     domain = "vpc"
# }
# resource "aws_nat_gateway" "nat_gw" {
#     allocation_id = aws_eip.nat_eip.id
#     subnet_id     = aws_subnet.subnets[2].id

#     tags = {
#         Name = "nat-gateway"
#     }
  
# }

# #Private Route Table
# resource "aws_route_table" "private_route_table" {
#     vpc_id = aws_vpc.main_vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         nat_gateway_id = aws_nat_gateway.nat_gw.id

#     }
  
# }
# #Associate Private Subnets with Private Route Table
# resource "aws_route_table_association" "private_association" {
#     count = 2
    
#     subnet_id      = aws_subnet.subnets[count.index + 2].id
#     route_table_id = aws_route_table.private_route_table.id
  
# }





