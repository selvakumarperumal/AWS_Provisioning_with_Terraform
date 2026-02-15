data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# --- KMS Key (optional) ---
resource "aws_kms_key" "secret" {
  count = var.enable_kms ? 1 : 0

  description             = "KMS key for ${var.secret_name}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootAccount"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.secret_name}-kms"
  })
}

resource "aws_kms_alias" "secret" {
  count = var.enable_kms ? 1 : 0

  name          = "alias/${replace(var.secret_name, "/", "-")}"
  target_key_id = aws_kms_key.secret[0].key_id
}

# --- Secret ---
resource "aws_secretsmanager_secret" "main" {
  name                    = var.secret_name
  description             = var.secret_description
  recovery_window_in_days = var.recovery_window_in_days
  kms_key_id              = var.enable_kms ? aws_kms_key.secret[0].arn : null

  tags = merge(var.tags, {
    Name = var.secret_name
  })
}

# --- Secret Version (the actual value) ---
resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = var.secret_value
}

# --- IAM Policy to read this secret ---
resource "aws_iam_policy" "reader" {
  name        = "${replace(var.secret_name, "/", "-")}-reader"
  description = "Allows reading secret ${var.secret_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
        ]
        Resource = aws_secretsmanager_secret.main.arn
      },
      {
        Effect   = "Allow"
        Action   = "kms:Decrypt"
        Resource = var.enable_kms ? aws_kms_key.secret[0].arn : "*"
        Condition = var.enable_kms ? {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${data.aws_region.current.name}.amazonaws.com"
          }
        } : null
      }
    ]
  })

  tags = var.tags
}
