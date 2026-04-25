resource "aws_s3_bucket" "incoming_photos" {
  bucket        = var.incoming_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "processed_photos" {
  bucket        = var.processed_bucket_name
  force_destroy = true
}

resource "aws_dynamodb_table" "photo_metadata" {
  name         = var.metadata_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "photo_id"

  attribute {
    name = "photo_id"
    type = "S"
  }
}
