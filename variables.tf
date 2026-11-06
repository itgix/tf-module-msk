################################################################################
# Provider variables
################################################################################

variable "aws_region" {
  type        = string
  description = "AWS region to deploy to"
}

################################################################################
# Utility variables
################################################################################

variable "environment" {
  type        = string
  description = "Environment in which resources are deployed"
}

variable "product_name" {
  type        = string
  description = "Bango platform instance (same as provided tag in default_tags)"
}

################################################################################
# Networking variables
################################################################################

variable "msk_vpc_cidr" {
  type        = string
  description = "CIDR of VPC to be used by MSK cluster. This value will be ignored in case msk_create_vpc is set to false."
  default     = ""
}

variable "msk_vpc_id" {
  type        = string
  description = "ID of VPC to be used by MSK cluster. This value will be ignored in case msk_create_vpc is set to true."
  default     = ""
}

variable "msk_subnet_ids" {
  type        = list(string)
  description = "IDs of subnets to be used by MSK cluster. This value will be ignored in case msk_create_vpc is set to true."
  default     = []
}


variable "allowed_cidr_blocks" {
  type        = list(any)
  description = "List of CIDRs allowed by the security group"
}

variable "msk_vpc_subnet_newbits" {
  type        = number
  default     = 8
  description = "Number of additional bits with which to extend the prefix. This value will be ignored in case msk_create_vpc is set to false"
}

variable "msk_create_vpc" {
  type        = bool
  default     = true
  description = "The default for creating a VPC where to provision MSK"
}

variable "msk_broker_count" {
  type        = number
  default     = 3
  description = "Number of Kafka broker nodes in the MSK cluster. Valid values are 2 or 3. This controls the number of AZs used (broker_count = number_of_AZs × broker_per_zone). Note: This is not a neat implementation - it works by controlling the subnet count. WARNING: Changing this value on an existing cluster will trigger cluster recreation with downtime and data loss. This value will be ignored if msk_create_vpc is set to false."
  validation {
    condition     = var.msk_broker_count > 1
    error_message = "The msk_broker_count must be greater than 1"
  }
}
################################################################################
# Logging info variables
################################################################################

variable "jmx_exporter_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable the JMX Exporter."
  default     = false
}

variable "node_exporter_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable the Node Exporter."
  default     = false
}

variable "enhanced_monitoring" {
  type        = string
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: DEFAULT, PER_BROKER, and PER_TOPIC_PER_BROKER"
  default     = "DEFAULT"
}

variable "firehose_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
  default     = false
}

variable "s3_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to S3"
  default     = true
}

variable "s3_log_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to deliver logs to. Needed if `s3_logs_enabled` or `firehose_logs_enabled` are set to `true`"
  default     = ""
}

variable "s3_logs_prefix" {
  type        = string
  description = "Prefix to append to the S3 folder name logs are delivered to"
  default     = ""
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs."
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the log group"
  default     = 0
}

################################################################################
# Authentication variables
################################################################################

variable "client_broker" {
  type        = string
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. Plaintext traffic isn't possible with SASL/SCRAM or IAM access control methods."
  default     = "TLS"
}

variable "client_tls_auth_enabled" {
  type        = bool
  description = "Set true to enable the Client TLS Authentication"
  default     = false
}

variable "certificate_authority_arns" {
  type        = list(string)
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
  default     = []
}

variable "client_sasl_iam_enabled" {
  type        = bool
  description = "Enables client authentication via IAM policies (cannot be set to true at the same time as client_sasl_*_enabled)."
  default     = true
}

variable "client_sasl_scram_enabled" {
  type        = bool
  description = "Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to true at the same time as client_tls_auth_enabled)."
  default     = false
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  description = "List of AWS Secrets Manager secret ARNs for scram authentication (cannot be set to true at the same time as client_tls_auth_enabled)."
  default     = []
}

variable "client_allow_unauthenticated" {
  type        = bool
  default     = false
  description = "Enables unauthenticated access."
}

################################################################################
# MSK variables                                                                #
################################################################################

variable "msk_cluster_kafka_version" {
  type        = string
  description = "The desired Kafka software version"
}
variable "msk_cluster_broker_per_zone" {
  type        = number
  description = "Number of Kafka brokers per zone."
}
variable "msk_cluster_broker_node_instance_type" {
  type        = string
  description = "The instance type to use for the Kafka brokers"
}
variable "msk_cluster_broker_node_ebs_volume_size" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "storage_autoscaling_max_capacity" {
  type        = number
  description = "Maximum size the autoscaling policy can scale storage. Defaults to msk_cluster_broker_node_ebs_volume_size"
  default     = null
}

variable "storage_autoscaling_target_value" {
  type        = number
  default     = 80
  description = "Percentage of storage used to trigger autoscaled storage increase"
}

variable "server_properties" {
  type        = map(string)
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
  default     = {}
}
