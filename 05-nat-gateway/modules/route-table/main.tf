# ──────────────────────────────────────────────
# Public Route Table → routes to Internet Gateway
# ──────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = { Name = "public-route-table" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}

# ──────────────────────────────────────────────
# Private Route Table → routes to NAT Gateway
# ──────────────────────────────────────────────
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = { Name = "private-route-table" }
}

resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private.id
}
