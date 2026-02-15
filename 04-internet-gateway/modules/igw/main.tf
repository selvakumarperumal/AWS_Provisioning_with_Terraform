# ──────────────────────────────────────────────
# Internet Gateway
# ──────────────────────────────────────────────
# Allows bidirectional internet access for the VPC
# Must be attached to a VPC (1 IGW per VPC limit)
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "main-igw"
  }
}
