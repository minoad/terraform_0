output "incoming_bucket_name" {
  description = "Name of the bucket for raw photo uploads."
  value       = module.photo_processor.incoming_bucket_name
}

output "processed_bucket_name" {
  description = "Name of the bucket for processed photo output."
  value       = module.photo_processor.processed_bucket_name
}

output "metadata_table_name" {
  description = "Name of the DynamoDB metadata table."
  value       = module.photo_processor.metadata_table_name
}

output "lambda_function_name" {
  description = "Name of the photo processor Lambda function."
  value       = module.photo_processor.lambda_function_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for photo processing notifications."
  value       = module.photo_processor.sns_topic_arn
}

output "sqs_queue_url" {
  description = "URL of the SQS queue for photo notifications."
  value       = module.photo_processor.sqs_queue_url
}

output "local_test_commands" {
  description = "Useful awslocal commands for inspecting this stack."
  value = {
    list_buckets     = "awslocal --region ${var.aws_region} s3 ls"
    list_tables      = "awslocal --region ${var.aws_region} dynamodb list-tables"
    list_functions   = "awslocal --region ${var.aws_region} lambda list-functions"
    list_topics      = "awslocal --region ${var.aws_region} sns list-topics"
    list_queues      = "awslocal --region ${var.aws_region} sqs list-queues"
    invoke_processor = "awslocal --region ${var.aws_region} lambda invoke --function-name ${module.photo_processor.lambda_function_name} --payload file://sample-lambda-event.json --cli-binary-format raw-in-base64-out response.json"
    upload_file      = "awslocal --region ${var.aws_region} s3 cp .\\sample-photo.txt s3://${module.photo_processor.incoming_bucket_name}/sample-photo.txt"
    receive_message  = "awslocal --region ${var.aws_region} sqs receive-message --queue-url ${module.photo_processor.sqs_queue_url}"
  }
}
