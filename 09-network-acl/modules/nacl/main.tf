# ──────────────────────────────────────────────
# Public Subnet NACL
# ──────────────────────────────────────────────
resource "aws_network_acl" "public" {
  vpc_id     = var.vpc_id
  subnet_ids = [var.public_subnet_id]
  tags       = { Name = "public-nacl" }
}

# Inbound: Allow HTTP
resource "aws_network_acl_rule" "public_inbound_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Inbound: Allow HTTPS
resource "aws_network_acl_rule" "public_inbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Inbound: Allow SSH
resource "aws_network_acl_rule" "public_inbound_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.ssh_cidr
  from_port      = 22
  to_port        = 22
}

# Inbound: Allow ephemeral ports (return traffic)
resource "aws_network_acl_rule" "public_inbound_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 900
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound: Allow HTTP
resource "aws_network_acl_rule" "public_outbound_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Outbound: Allow HTTPS
resource "aws_network_acl_rule" "public_outbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Outbound: Allow ephemeral ports (response traffic)
resource "aws_network_acl_rule" "public_outbound_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 900
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# ──────────────────────────────────────────────
# Private Subnet NACL
# ──────────────────────────────────────────────
resource "aws_network_acl" "private" {
  vpc_id     = var.vpc_id
  subnet_ids = [var.private_subnet_id]
  tags       = { Name = "private-nacl" }
}

# Inbound: Allow MySQL from public subnet only
resource "aws_network_acl_rule" "private_inbound_mysql" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.public_subnet_cidr
  from_port      = 3306
  to_port        = 3306
}

# Inbound: Allow ephemeral return traffic
resource "aws_network_acl_rule" "private_inbound_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 900
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound: Allow ephemeral ports to public subnet
resource "aws_network_acl_rule" "private_outbound_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 900
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.public_subnet_cidr
  from_port      = 1024
  to_port        = 65535
}

# Outbound: Allow HTTPS (for package updates via NAT)
resource "aws_network_acl_rule" "private_outbound_https" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}
