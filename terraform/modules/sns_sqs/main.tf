resource "aws_sns_topic" "order_processing" {
  name = "order-processing-events"
}

resource "aws_sqs_queue" "order_processing" {
  name                       = "order-processing-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600  # 4 days
  receive_wait_time_seconds  = 20
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.order_processing.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_processing.arn
}

# Queue Policy 允許 SNS Topic 發訊息
resource "aws_sqs_queue_policy" "order_processing_policy" {
  queue_url = aws_sqs_queue.order_processing.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.order_processing.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.order_processing.arn
          }
        }
      }
    ]
  })
}