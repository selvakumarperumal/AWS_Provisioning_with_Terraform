# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "nat-gateway-eip" }
}

# NAT Gateway — placed in PUBLIC subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id
  tags          = { Name = "main-nat-gateway" }
  depends_on    = [var.igw_id]
}
