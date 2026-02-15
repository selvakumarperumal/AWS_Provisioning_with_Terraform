# --- S3 Bucket ---
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

# --- Website Configuration ---
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# --- Public Access Block (allow public for website) ---
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# --- Bucket Policy (public read) ---
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# --- CORS Configuration ---
resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }
}

# --- Upload index.html ---
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = var.index_document
  content_type = "text/html"

  content = <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Welcome</title>
      <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f0f0f0; }
        h1 { color: #232f3e; }
        p { color: #666; }
      </style>
    </head>
    <body>
      <h1>Hello from S3 Static Website!</h1>
      <p>This page is served from Amazon S3.</p>
      <p>Deployed with Terraform.</p>
    </body>
    </html>
  HTML

  tags = var.tags
}

# --- Upload error.html ---
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website.id
  key          = var.error_document
  content_type = "text/html"

  content = <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Error</title>
      <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f0f0f0; }
        h1 { color: #dd3522; }
        p { color: #666; }
      </style>
    </head>
    <body>
      <h1>404 - Page Not Found</h1>
      <p>The page you are looking for does not exist.</p>
    </body>
    </html>
  HTML

  tags = var.tags
}
