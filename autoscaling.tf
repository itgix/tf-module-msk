# Replaces the CloudPosse module's storage autoscaling target, which has no tags input;
# SCPs that mandate tags deny RegisterScalableTarget without them.
resource "aws_appautoscaling_target" "msk_storage" {
  max_capacity       = coalesce(var.storage_autoscaling_max_capacity, var.msk_cluster_broker_node_ebs_volume_size)
  min_capacity       = 1
  resource_id        = module.kafka.cluster_arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
  tags               = var.tags
}

resource "aws_appautoscaling_policy" "msk_storage" {
  name               = "${module.kafka.cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.msk_storage.resource_id
  scalable_dimension = aws_appautoscaling_target.msk_storage.scalable_dimension
  service_namespace  = aws_appautoscaling_target.msk_storage.service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in = false

    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_autoscaling_target_value
  }
}

moved {
  from = module.kafka.aws_appautoscaling_target.default[0]
  to   = aws_appautoscaling_target.msk_storage
}

moved {
  from = module.kafka.aws_appautoscaling_policy.default[0]
  to   = aws_appautoscaling_policy.msk_storage
}
