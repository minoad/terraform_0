resource "aws_s3_bucket" "incoming_photos" {
  bucket        = var.incoming_bucket_name
  force_destroy = var.force_destroy_buckets
}

resource "aws_s3_bucket" "processed_photos" {
  bucket        = var.processed_bucket_name
  force_destroy = var.force_destroy_buckets
}

resource "aws_s3_bucket_notification" "incoming_photos" {
  bucket = aws_s3_bucket.incoming_photos.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.photo_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
