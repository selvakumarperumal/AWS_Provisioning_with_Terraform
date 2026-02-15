# ──────────────────────────────────────────────
# Public Subnet (will have IGW route)
# ──────────────────────────────────────────────
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_subnet_cidr}-public-subnet"
    Type = "public"
  }
}

# ──────────────────────────────────────────────
# Private Subnet (no IGW route)
# ──────────────────────────────────────────────
resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.private_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.private_subnet_cidr}-private-subnet"
    Type = "private"
  }
}
