resource "aws_lambda_function" "image_generator" {
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  function_name    = "${var.prefix}-image-generator-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.12"
  timeout          = 300
  memory_size      = 256

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name,
      IMAGE_PATH  = var.image_path
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_generation_queue.arn
  function_name    = aws_lambda_function.image_generator.function_name
  batch_size       = 1
}
