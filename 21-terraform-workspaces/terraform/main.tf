# --- Environment-specific configuration via workspaces ---
locals {
  environment = terraform.workspace

  # Different CIDR per environment
  vpc_cidr = lookup({
    dev     = "10.0.0.0/16"
    staging = "10.1.0.0/16"
    prod    = "10.2.0.0/16"
  }, terraform.workspace, "10.0.0.0/16")

  subnet_cidr = lookup({
    dev     = "10.0.1.0/24"
    staging = "10.1.1.0/24"
    prod    = "10.2.1.0/24"
  }, terraform.workspace, "10.0.1.0/24")

  # Different instance types per environment
  instance_type = lookup({
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }, terraform.workspace, "t3.micro")
}

module "network" {
  source = "../modules/network"

  vpc_cidr          = local.vpc_cidr
  subnet_cidr       = local.subnet_cidr
  availability_zone = "${var.aws_region}a"
  environment       = local.environment

  tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
    Workspace   = terraform.workspace
  }
}
