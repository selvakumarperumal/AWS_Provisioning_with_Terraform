module "monitoring" {
  source = "../modules/monitoring"

  project_name = var.project_name
  alarm_email  = var.alarm_email
  instance_id  = var.instance_id
  aws_region   = var.aws_region

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
