resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr_block)
  vpc_id = var.vpc_id
  cidr_block = element(var.subnet_cidr_block, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-for-ip-output-${count.index}"
  }
  
}

