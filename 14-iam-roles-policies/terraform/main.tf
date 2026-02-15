module "iam" {
  source    = "../modules/iam"
  role_name = var.role_name
}

resource "aws_key_pair" "deployer" {
  key_name   = "iam-demo-key"
  public_key = file(var.public_key_path)
}

module "ec2" {
  source                = "../modules/ec2"
  vpc_cidr              = var.vpc_cidr
  subnet_cidr           = var.subnet_cidr
  availability_zone     = var.availability_zone
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = aws_key_pair.deployer.key_name
  instance_profile_name = module.iam.instance_profile_name
}
