
## v1.0.3

### Features

* **tags:** The storage autoscaling target is now tagged with `tags`, so the module applies in accounts whose SCP mandates tags (itgix idp-installer#335). The CloudPosse MSK module's own target has no tags input, so its autoscaling is turned off (`autoscaling_enabled = false`) and this module creates `aws_appautoscaling_target.msk_storage` and `aws_appautoscaling_policy.msk_storage` with the same settings and policy name. `moved` blocks carry existing state over from `module.kafka.aws_appautoscaling_target.default[0]` and `module.kafka.aws_appautoscaling_policy.default[0]`, so an existing environment's plan shows only the tag addition on the target.

## v1.0.2

### Features

* **tags:** New `tags` input (`map(string)`, default `{}`) applied to the KMS key, MSK cluster, VPC resources, security group, CloudWatch log group, Firehose delivery stream and its IAM role, so accounts whose SCP mandates tags can deploy the module (itgix idp-installer#346). The storage autoscaling target inside the CloudPosse MSK module stays untagged; the upstream module exposes no input for it.

### Features

* **** This module uses CloudPosse version 2.4.0
