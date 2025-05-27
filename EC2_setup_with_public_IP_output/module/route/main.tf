resource "aws_route_table" "rt" {
    vpc_id = var.vpc_id
    tags = {
        Name = "route-table-for-ip-output"
    }
}

resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.rt.id
    destination_cidr_block ="0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  
}

resource "aws_route_table_association" "rta" {
    count = length(var.subnet_ids)
    subnet_id = element(var.subnet_ids, count.index)
    route_table_id = aws_route_table.rt.id
  
}



