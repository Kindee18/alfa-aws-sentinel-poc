provider "aws" {
  region = "us-east-1"
}

# EC2 Instance to monitor
resource "aws_instance" "app_server" {
  ami           = "ami-0c101f26f147fa7fd" # Amazon Linux 2023
  instance_type = "t3.micro"

  tags = {
    Name        = "alfa-mission-critical-app"
    Environment = "prod-operations-demo"
  }
}

# CloudWatch Alarm for Status Check Failure
resource "aws_cloudwatch_metric_alarm" "status_check_alarm" {
  alarm_name          = "alfa-status-check-failure"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This alarm triggers when the EC2 status check fails, simulating a production incident."
  
  dimensions = {
    InstanceId = aws_instance.app_server.id
  }

  alarm_actions = [aws_lambda_function.remediator.arn]
}

# Lambda function for Self-Healing (to be defined in lambda/)
resource "aws_lambda_function" "remediator" {
  filename      = "lambda/remediator.zip"
  function_name = "alfa-self-healing-remediator"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "remediator.lambda_handler"
  runtime       = "python3.10"

  environment {
    variables = {
      INSTANCE_ID = aws_instance.app_server.id
    }
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "alfa_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for EC2 Reboot permissions
resource "aws_iam_role_policy" "lambda_ec2_policy" {
  name = "lambda_ec2_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "ec2:RebootInstances",
        "ec2:DescribeInstances",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# Permission for CloudWatch to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remediator.function_name
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn    = aws_cloudwatch_metric_alarm.status_check_alarm.arn
}
