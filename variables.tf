variable "aws_region" {
  description = "AWS region used by LocalStack."
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "LocalStack edge endpoint."
  type        = string
  default     = "http://localhost:4566"
}

variable "incoming_bucket_name" {
  description = "Bucket where raw photo uploads land."
  type        = string
  default     = "incoming-photos"
}

variable "processed_bucket_name" {
  description = "Bucket where processed photo output is written."
  type        = string
  default     = "processed-photos"
}

variable "metadata_table_name" {
  description = "DynamoDB table for photo metadata."
  type        = string
  default     = "photo_metadata"
}
