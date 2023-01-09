output "topic_name" {
  description = "the name of the topic created"
  value       = module.pubsub.topic_name
}

output "subscription_name" {
  description = "the name of the subscription created"
  value       = module.pubsub.subscription_name
}
