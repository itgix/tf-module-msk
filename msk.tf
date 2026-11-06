#tfsec:ignore:aws-kms-no-policy-wildcards
resource "aws_kms_key" "msk" {
  description         = "MSK cluster encryption key"
  enable_key_rotation = true
}

#tfsec:ignore:aws-ec2-add-description-to-security-group
module "kafka" {
  source  = "cloudposse/msk-apache-kafka-cluster/aws"
  version = "~> 2.4.0"

  name                = local.msk_name
  kafka_version       = var.msk_cluster_kafka_version
  properties          = var.server_properties
  enhanced_monitoring = var.enhanced_monitoring

  ## broker node group
  broker_instance_type             = var.msk_cluster_broker_node_instance_type
  broker_volume_size               = var.msk_cluster_broker_node_ebs_volume_size
  broker_per_zone                  = var.msk_cluster_broker_per_zone
  storage_autoscaling_max_capacity = var.storage_autoscaling_max_capacity
  storage_autoscaling_target_value = var.storage_autoscaling_target_value

  ## Networking
  vpc_id                        = local.msk_vpc_id
  subnet_ids                    = local.msk_subnet_ids
  create_security_group         = false
  associated_security_group_ids = [aws_security_group.msk_cluster_sg.id]

  ## Encryption
  client_broker                  = var.client_broker
  encryption_at_rest_kms_key_arn = aws_kms_key.msk.arn

  ## Authentication
  client_tls_auth_enabled      = var.client_tls_auth_enabled
  certificate_authority_arns   = var.certificate_authority_arns
  client_allow_unauthenticated = var.client_allow_unauthenticated

  client_sasl_iam_enabled                   = var.client_sasl_iam_enabled
  client_sasl_scram_enabled                 = var.client_sasl_scram_enabled
  client_sasl_scram_secret_association_arns = var.client_sasl_scram_secret_association_arns

  ## Open monitoring
  jmx_exporter_enabled  = var.jmx_exporter_enabled
  node_exporter_enabled = var.node_exporter_enabled

  ##  Logging
  # Cloudwatch
  cloudwatch_logs_enabled   = var.cloudwatch_logs_enabled
  cloudwatch_logs_log_group = local.cloudwatch_logs_log_group
  # Firehose
  firehose_logs_enabled    = var.firehose_logs_enabled
  firehose_delivery_stream = local.firehose_delivery_stream
  # s3
  s3_logs_enabled = var.s3_logs_enabled
  s3_logs_bucket  = var.s3_log_bucket_name
  s3_logs_prefix  = local.s3_logs_prefix

}
