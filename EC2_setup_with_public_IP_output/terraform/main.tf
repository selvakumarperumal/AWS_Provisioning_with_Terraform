# VPC Module
# Creates a Virtual Private Cloud (VPC) with specified CIDR block
module "vpc" {
  source = "../module/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

# Subnet Module
# Creates subnets within the VPC across specified availability zones
module "subnet" {
  source = "../module/subnet"
  vpc_id = module.vpc.vpc_id
  subnet_cidr_block = var.subnet_cidr_block
  availability_zones = var.availability_zones
}

# Internet Gateway Module
# Creates an Internet Gateway and attaches it to the VPC for internet connectivity
module "internet_gateway" {
  source = "../module/igw"
  vpc_id = module.vpc.vpc_id
}

# Route Module
# Configures routing tables to direct traffic between subnets and internet gateway
module "route" {
  source = "../module/route"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.subnet.subnet_ids
  internet_gateway_id = module.internet_gateway.igw_id
}

# Security Group Module
# Defines security rules for inbound and outbound traffic in the VPC
module "security_group" {
  source = "../module/sg"
  vpc_id = module.vpc.vpc_id  
}

#Key Pair
# Creates an EC2 key pair for SSH access to the instance
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key-pair"
  public_key = file(var.public_key_path)
}

# EC2 Instance Module
# Launches an EC2 instance within the specified subnet and security group
module "instance" {
  source = "../module/instance"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_ids = module.subnet.subnet_ids
  security_group_id = module.security_group.security_group_id
  # Use the key name from the created key pair
  public_key = aws_key_pair.ec2_key_pair.key_name
}

#Output Public IP
# Outputs the public IP address of the EC2 instance for easy access
output "instance_public_ip" {
  value = module.instance.instance_public_ip
}