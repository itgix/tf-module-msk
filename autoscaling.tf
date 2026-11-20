locals {
  # Regions where Amazon MSK has no storage autoscaling: https://docs.aws.amazon.com/msk/latest/developerguide/msk-autoexpand.html
  msk_storage_autoscaling_unsupported_regions = ["ap-northeast-3", "af-south-1", "ap-southeast-5"]
}

# Replaces the CloudPosse module's storage autoscaling target, which has no tags input;
# SCPs that mandate tags deny RegisterScalableTarget without them.
resource "aws_appautoscaling_target" "msk_storage" {
  count = var.storage_autoscaling_enabled ? 1 : 0

  max_capacity       = coalesce(var.storage_autoscaling_max_capacity, var.msk_cluster_broker_node_ebs_volume_size)
  min_capacity       = 1
  resource_id        = module.kafka.cluster_arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
  tags               = var.tags
}

resource "aws_appautoscaling_policy" "msk_storage" {
  count = var.storage_autoscaling_enabled ? 1 : 0

  name               = "${module.kafka.cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.msk_storage[0].resource_id
  scalable_dimension = aws_appautoscaling_target.msk_storage[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.msk_storage[0].service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in = false

    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_autoscaling_target_value
  }
}

# Chained moves: v1.0.2 and earlier held the CloudPosse module's target and policy,
# v1.0.3 held them un-indexed; both land on [0]. The explicit blocks disable the implicit move.
moved {
  from = module.kafka.aws_appautoscaling_target.default[0]
  to   = aws_appautoscaling_target.msk_storage
}

moved {
  from = aws_appautoscaling_target.msk_storage
  to   = aws_appautoscaling_target.msk_storage[0]
}

moved {
  from = module.kafka.aws_appautoscaling_policy.default[0]
  to   = aws_appautoscaling_policy.msk_storage
}

moved {
  from = aws_appautoscaling_policy.msk_storage
  to   = aws_appautoscaling_policy.msk_storage[0]
}
