resource "aws_sqs_queue" "image_generation_queue_deadletter" {
  name                      = "${var.prefix}-image-generation-dlq-${var.environment}"
  delay_seconds             = 0
  max_message_size         = 262144
  message_retention_seconds = 1209600
  
  tags = {
    Environment = var.environment
  }
}

resource "aws_sqs_queue" "image_generation_queue" {
  name                      = "${var.prefix}-image-generation-queue-${var.environment}"
  delay_seconds             = 0
  max_message_size         = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.image_generation_queue_deadletter.arn
    maxReceiveCount     = 4
  })
  
  tags = {
    Environment = var.environment
  }
}