data "archive_file" "photo_processor" {
  type        = "zip"
  source_file = "${path.module}/lambda/photo_processor.py"
  output_path = "${path.module}/lambda/photo_processor.zip"
}

resource "aws_lambda_function" "photo_processor" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.photo_processor.arn
  handler          = "photo_processor.handler"
  runtime          = "python3.11"
  filename         = data.archive_file.photo_processor.output_path
  source_code_hash = data.archive_file.photo_processor.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      METADATA_TABLE_NAME   = aws_dynamodb_table.photo_metadata.name
      PROCESSED_BUCKET_NAME = aws_s3_bucket.processed_photos.bucket
      SNS_TOPIC_ARN         = aws_sns_topic.photo_processed.arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.photo_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.incoming_photos.arn
}
