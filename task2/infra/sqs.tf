resource "aws_sns_topic" "queue_alerts" {
  name = "${var.prefix}-queue-alerts-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "queue_alerts_email" {
  topic_arn = aws_sns_topic.queue_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email_address
}


resource "aws_sqs_queue" "image_generation_queue_deadletter" {
  name                      = "${var.prefix}-image-generation-dlq-${var.environment}"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 1209600

  tags = {
    Environment = var.environment
  }
}

resource "aws_sqs_queue" "image_generation_queue" {
  name                       = "${var.prefix}-image-generation-queue-${var.environment}"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.image_generation_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "queue_message_age" {
  alarm_name          = "${var.prefix}-queue-message-age-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "60"
  alarm_description   = "Alert when messages are older than 5 minutes"
  alarm_actions       = [aws_sns_topic.queue_alerts.arn]

  dimensions = {
    QueueName = aws_sqs_queue.image_generation_queue.name
  }

  tags = {
    Environment = var.environment
  }
}
