output "main_queue_url" {
  value = aws_sqs_queue.image_generation_queue.url
}

output "dlq_queue_url" {
  value = aws_sqs_queue.image_generation_queue_deadletter.url
}

output "lambda_function_arn" {
  value = aws_lambda_function.image_generator.arn
}