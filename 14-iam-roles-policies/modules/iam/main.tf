# ──────────────────────────────────────────────
# IAM Role — Trust Policy (who can assume)
# ──────────────────────────────────────────────
resource "aws_iam_role" "ec2_role" {
  name = var.role_name

  # Trust policy — allows EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = { Name = var.role_name }
}

# ──────────────────────────────────────────────
# IAM Policy — Permission Policy (what can do)
# ──────────────────────────────────────────────
resource "aws_iam_policy" "s3_read" {
  name        = "${var.role_name}-s3-read"
  description = "Allow reading from S3 and writing CloudWatch logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ReadAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "DescribeEC2"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# ──────────────────────────────────────────────
# Attach Policy to Role
# ──────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read.arn
}

# Also attach AWS managed policy for SSM (optional)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ──────────────────────────────────────────────
# Instance Profile — bridge between Role and EC2
# ──────────────────────────────────────────────
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.ec2_role.name
}
