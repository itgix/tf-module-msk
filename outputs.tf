output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.kafka.cluster_arn
}

output "cluster_name" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.kafka.cluster_name
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
  value       = module.kafka.zookeeper_connect_string
}

output "bootstrap_brokers" {
  description = "A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster"
  value       = module.kafka.bootstrap_brokers
}

output "msk_vpc_id" {
  description = "The ID of the MSK VPC"
  value       = local.msk_vpc_id
}

output "intra_subnet_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = var.msk_create_vpc ? module.msk_vpc.intra_route_table_ids : null
}

output "msk_create_vpc" {
  description = "If the MSK VPC will be created"
  value       = var.msk_create_vpc ? "true" : "false"
}
