output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
  
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.subnets[*].id
  
  # This will output a list of all subnet IDs created in the module
  # The `[*]` syntax is used to extract the `id` attribute from each subnet resource
  # in the `aws_subnet.subnets` list.
  # This is useful for referencing the subnets in other parts of your Terraform configuration
  # or for passing them to other modules.
  # For example, you might want to use these subnet IDs when creating EC2 instances,
  # load balancers, or other resources that require a subnet.
  # By outputting the subnet IDs, you can easily access them without having to
  # hardcode the values or look them up manually.
  # This output will be a list of strings, each representing the ID of a subnet.
  # The output will look something like this:
  # subnet_ids = [
  #   "subnet-0123456789abcdef0",
  #   "subnet-0123456789abcdef1",
  #   "subnet-0123456789abcdef2",
  # ]
  
}