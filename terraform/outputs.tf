output "ecs_cluster_name" {
  description = "Name of the created ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the running ECS service"
  value       = module.ecs.service_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN from the messaging module"
  value       = module.messaging.sns_topic_arn
}

output "sqs_queue_url" {
  description = "SQS queue URL from the messaging module"
  value       = module.messaging.sqs_queue_url
}