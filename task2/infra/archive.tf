data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_sqs.py"
  output_path = "${path.module}/lambda_sqs_payload.zip"
}