# ──────────────────────────────────────────────
# Elastic IP for NAT Gateway
# ──────────────────────────────────────────────
# A static public IP that persists even if NAT is recreated
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip"
  }
}

# ──────────────────────────────────────────────
# NAT Gateway
# ──────────────────────────────────────────────
# MUST be placed in a PUBLIC subnet
# Allows private subnet instances to reach internet (outbound only)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "main-nat-gateway"
  }

  # NAT Gateway depends on the IGW existing first
  depends_on = [var.igw_id]
}
