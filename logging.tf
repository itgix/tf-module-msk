#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "msk" {
  count             = var.cloudwatch_logs_enabled ? 1 : 0
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_group_retention_in_days
}

resource "aws_iam_role" "firehose_role" {
  count = var.firehose_logs_enabled ? 1 : 0
  name  = local.firehose_role_name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          "Service" : "firehose.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
}

#tfsec:ignore:aws-kinesis-enable-in-transit-encryption
resource "aws_kinesis_firehose_delivery_stream" "msk" {
  count       = var.firehose_logs_enabled ? 1 : 0
  name        = local.firehose_delivery_stream_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role[0].arn
    bucket_arn = "arn:aws:s3:::${var.s3_log_bucket_name}"
  }

  tags = {
    LogDeliveryEnabled = "false"
  }

  lifecycle {
    ignore_changes = [
      tags["LogDeliveryEnabled"],
    ]
  }
}
