output "incoming_bucket_name" {
  description = "Name of the bucket for raw photo uploads."
  value       = aws_s3_bucket.incoming_photos.bucket
}

output "processed_bucket_name" {
  description = "Name of the bucket for processed photo output."
  value       = aws_s3_bucket.processed_photos.bucket
}

output "metadata_table_name" {
  description = "Name of the DynamoDB metadata table."
  value       = aws_dynamodb_table.photo_metadata.name
}

output "lambda_function_name" {
  description = "Name of the photo processor Lambda function."
  value       = aws_lambda_function.photo_processor.function_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for photo processing notifications."
  value       = aws_sns_topic.photo_processed.arn
}

output "sqs_queue_url" {
  description = "URL of the SQS queue for photo notifications."
  value       = aws_sqs_queue.photo_notifications.url
}
