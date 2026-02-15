# --- S3 Origin Bucket (Private) ---
resource "aws_s3_bucket" "origin" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

# --- Block ALL public access (CF uses OAC) ---
resource "aws_s3_bucket_public_access_block" "origin" {
  bucket = aws_s3_bucket.origin.id

  block_public_acls       = true
  block_public_policy     = false  # Allow CF bucket policy
  ignore_public_acls      = true
  restrict_public_buckets = false  # Allow CF bucket policy
}

# --- Origin Access Control ---
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# --- CloudFront Distribution ---
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = var.price_class
  comment             = "CDN for ${var.bucket_name}"

  origin {
    domain_name              = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  }

  # --- Custom error response (SPA support) ---
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, {
    Name = "${var.bucket_name}-cdn"
  })
}

# --- S3 Bucket Policy for CloudFront OAC ---
resource "aws_s3_bucket_policy" "origin" {
  bucket = aws_s3_bucket.origin.id

  depends_on = [aws_s3_bucket_public_access_block.origin]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontOAC"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.origin.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}

# --- Upload index.html ---
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.origin.id
  key          = "index.html"
  content_type = "text/html"

  content = <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>CloudFront CDN</title>
      <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f0f0f0; }
        h1 { color: #ff9900; } p { color: #666; }
      </style>
    </head>
    <body>
      <h1>Served via CloudFront CDN!</h1>
      <p>This page is delivered from the nearest edge location.</p>
      <p>Origin: Amazon S3 | Deployed with Terraform</p>
    </body>
    </html>
  HTML

  tags = var.tags
}
