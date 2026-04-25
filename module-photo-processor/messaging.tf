resource "aws_sns_topic" "photo_processed" {
  name = var.sns_topic_name
}

resource "aws_sqs_queue" "photo_notifications" {
  name = var.sqs_queue_name
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.photo_processed.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.photo_notifications.arn
}

resource "aws_sqs_queue_policy" "photo_notifications_policy" {
  queue_url = aws_sqs_queue.photo_notifications.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.photo_notifications.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.photo_processed.arn
          }
        }
      }
    ]
  })
}