
## v1.0.2

### Features

* **tags:** New `tags` input (`map(string)`, default `{}`) applied to the KMS key, MSK cluster, VPC resources, security group, CloudWatch log group, Firehose delivery stream and its IAM role, so accounts whose SCP mandates tags can deploy the module (itgix idp-installer#346). The storage autoscaling target inside the CloudPosse MSK module stays untagged; the upstream module exposes no input for it.

### Features

* **** This module uses CloudPosse version 2.4.0
