# ──────────────────────────────────────────────
# Public Route Table
# ──────────────────────────────────────────────
# Routes all non-VPC traffic (0.0.0.0/0) to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "public-route-table"
  }
}

# ──────────────────────────────────────────────
# Associate Public Subnet with Public Route Table
# ──────────────────────────────────────────────
# This is what actually makes the subnet "public"
resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}
