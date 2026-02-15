# ──────────────────────────────────────────────
# VPC A — Application VPC
# ──────────────────────────────────────────────
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "vpc-a-application" }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = var.availability_zone
  tags = { Name = "vpc-a-subnet" }
}

resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id
  tags   = { Name = "vpc-a-route-table" }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}

# ──────────────────────────────────────────────
# VPC B — Database VPC
# ──────────────────────────────────────────────
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "vpc-b-database" }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = var.subnet_b_cidr
  availability_zone = var.availability_zone
  tags = { Name = "vpc-b-subnet" }
}

resource "aws_route_table" "rt_b" {
  vpc_id = aws_vpc.vpc_b.id
  tags   = { Name = "vpc-b-route-table" }
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_b.id
}

# ──────────────────────────────────────────────
# VPC Peering Connection
# ──────────────────────────────────────────────
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc_a.id
  peer_vpc_id = aws_vpc.vpc_b.id
  auto_accept = true

  tags = { Name = "vpc-a-to-vpc-b-peering" }
}

# ──────────────────────────────────────────────
# Routes — Both directions!
# ──────────────────────────────────────────────

# VPC A → VPC B
resource "aws_route" "a_to_b" {
  route_table_id            = aws_route_table.rt_a.id
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# VPC B → VPC A
resource "aws_route" "b_to_a" {
  route_table_id            = aws_route_table.rt_b.id
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
