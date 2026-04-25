variable "incoming_bucket_name" {
  description = "Bucket where raw photo uploads land."
  type        = string
}

variable "processed_bucket_name" {
  description = "Bucket where processed photo output is written."
  type        = string
}

variable "metadata_table_name" {
  description = "DynamoDB table for photo metadata."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the photo processor Lambda function."
  type        = string
}

variable "force_destroy_buckets" {
  description = "Whether Terraform can delete non-empty buckets during destroy."
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for photo processing notifications."
  type        = string
  default     = "photo-processed"
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue for photo notifications."
  type        = string
  default     = "photo-notifications"
}
