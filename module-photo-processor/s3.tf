resource "aws_s3_bucket" "incoming_photos" {
  bucket        = var.incoming_bucket_name
  force_destroy = var.force_destroy_buckets
}

resource "aws_s3_bucket" "processed_photos" {
  bucket        = var.processed_bucket_name
  force_destroy = var.force_destroy_buckets
}
