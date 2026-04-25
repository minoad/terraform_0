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

output "local_test_commands" {
  description = "Useful awslocal commands for inspecting this stack."
  value = {
    list_buckets = "awslocal s3 ls"
    list_tables  = "awslocal dynamodb list-tables"
    upload_file  = "awslocal s3 cp .\\sample-photo.txt s3://${aws_s3_bucket.incoming_photos.bucket}/sample-photo.txt"
  }
}
