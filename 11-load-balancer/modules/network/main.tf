# Subnets — ALB requires at least 2 AZs
resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-${count.index + 1}" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = { Name = "alb-igw" }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
