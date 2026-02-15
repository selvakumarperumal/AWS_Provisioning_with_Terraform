module "lambda" {
  source = "../modules/lambda"

  function_name = var.function_name

  environment_variables = {
    ENVIRONMENT = "dev"
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
