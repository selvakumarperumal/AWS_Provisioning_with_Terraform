# --- Public Hosted Zone ---
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}

# --- A Record ---
resource "aws_route53_record" "a_record" {
  count = var.a_record_ip != "" ? 1 : 0

  zone_id = aws_route53_zone.main.zone_id
  name    = var.a_record_name != "" ? "${var.a_record_name}.${var.domain_name}" : var.domain_name
  type    = "A"
  ttl     = var.ttl
  records = [var.a_record_ip]
}

# --- CNAME Record (www → apex) ---
resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = var.ttl
  records = [var.domain_name]
}

# --- TXT Record (for verification/SPF) ---
resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = var.ttl
  records = ["v=spf1 -all"]
}

# --- Health Check ---
resource "aws_route53_health_check" "main" {
  count = var.enable_health_check && var.a_record_ip != "" ? 1 : 0

  ip_address        = var.a_record_ip
  port              = 80
  type              = "HTTP"
  resource_path     = var.health_check_path
  failure_threshold = 3
  request_interval  = 30

  tags = merge(var.tags, {
    Name = "${var.domain_name}-health-check"
  })
}
