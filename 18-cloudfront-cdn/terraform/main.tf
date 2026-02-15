module "cloudfront" {
  source = "../modules/cloudfront"

  bucket_name = var.bucket_name
  price_class = "PriceClass_100"

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
