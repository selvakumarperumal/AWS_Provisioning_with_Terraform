module "db_secret" {
  source = "../modules/secrets"

  secret_name        = "/dev/myapp/database-credentials"
  secret_description = "Database credentials for myapp"

  secret_value = jsonencode({
    username = var.db_username
    password = var.db_password
    engine   = "mysql"
    port     = 3306
  })

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
