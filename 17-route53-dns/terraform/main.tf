module "dns" {
  source = "../modules/dns"

  domain_name  = var.domain_name
  a_record_ip  = var.a_record_ip

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
