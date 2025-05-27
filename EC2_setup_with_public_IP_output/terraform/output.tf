output "vpc_id" {
  value = module.vpc.vpc_id
  # The value of the VPC ID is obtained from the module output
  description = "value of the VPC ID"
}