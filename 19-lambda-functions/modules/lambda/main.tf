# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# --- Attach basic execution policy (CloudWatch Logs) ---
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- CloudWatch Log Group ---
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14

  tags = var.tags
}

# --- Lambda Function Code (inline zip) ---
data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  source {
    content  = <<-PYTHON
      import json
      import os
      from datetime import datetime

      def lambda_handler(event, context):
          """Simple Lambda handler with API Gateway integration."""
          
          # Get environment variable
          env = os.environ.get("ENVIRONMENT", "unknown")
          
          # Build response
          response = {
              "message": "Hello from Lambda!",
              "environment": env,
              "timestamp": datetime.now().isoformat(),
              "path": event.get("rawPath", "/"),
              "method": event.get("requestContext", {}).get("http", {}).get("method", "GET"),
          }
          
          return {
              "statusCode": 200,
              "headers": {
                  "Content-Type": "application/json",
              },
              "body": json.dumps(response, indent=2),
          }
    PYTHON
    filename = "handler.py"
  }
}

# --- Lambda Function ---
resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda.arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = merge(var.environment_variables, {
      FUNCTION_NAME = var.function_name
    })
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda,
  ]

  tags = var.tags
}

# --- API Gateway HTTP API ---
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.function_name}-api"
  protocol_type = "HTTP"

  tags = var.tags
}

# --- API Gateway Stage (auto-deploy) ---
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true

  tags = var.tags
}

# --- Lambda Integration ---
resource "aws_apigatewayv2_integration" "main" {
  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.main.invoke_arn
  payload_format_version = "2.0"
}

# --- Route: GET /hello ---
resource "aws_apigatewayv2_route" "hello" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# --- Route: GET / (root) ---
resource "aws_apigatewayv2_route" "root" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# --- Lambda Permission (allow API GW to invoke) ---
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
