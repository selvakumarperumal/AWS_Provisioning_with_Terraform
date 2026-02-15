module "s3_website" {
  source = "../modules/s3-website"

  bucket_name = var.bucket_name

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
