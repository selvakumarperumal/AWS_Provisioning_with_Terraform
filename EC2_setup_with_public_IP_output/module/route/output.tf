output "rt_id" {
  value = aws_route_table.rt.id
  # The value of the route table ID is obtained from the module output
  description = "value of the route table ID"
  
}