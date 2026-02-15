module "backend" {
  source              = "../modules/backend"
  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
}
