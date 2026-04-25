module "photo_processor" {
  source = "../module-photo-processor"

  incoming_bucket_name  = var.incoming_bucket_name
  processed_bucket_name = var.processed_bucket_name
  metadata_table_name   = var.metadata_table_name
  lambda_function_name  = var.lambda_function_name
  sns_topic_name        = var.sns_topic_name
  sqs_queue_name        = var.sqs_queue_name
  force_destroy_buckets = true
}
