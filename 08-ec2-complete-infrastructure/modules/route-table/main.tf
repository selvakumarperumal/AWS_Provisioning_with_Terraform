# ──────────────────────────────────────────────
# Public Route Table → Internet Gateway
# ──────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = { Name = "public-route-table" }
}

# Associate all public subnets with public RT
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# ──────────────────────────────────────────────
# Private Route Table → NAT Gateway
# ──────────────────────────────────────────────
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }
  tags = { Name = "private-route-table" }
}

# Associate all private subnets with private RT
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
