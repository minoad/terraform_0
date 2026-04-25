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
