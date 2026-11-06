data "aws_availability_zones" "available" {
  state = "available"
}

#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
module "msk_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.1.0"

  name                 = local.vpc_name
  cidr                 = var.msk_vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, var.msk_broker_count)
  enable_dns_hostnames = true
  create_vpc           = var.msk_create_vpc
  ## Subnets
  intra_subnets = [
    for i in range(var.msk_broker_count) :
    cidrsubnet(var.msk_vpc_cidr, var.msk_vpc_subnet_newbits, i)
  ]
  intra_subnet_assign_ipv6_address_on_creation = false
  map_public_ip_on_launch                      = false

}

resource "aws_security_group" "msk_cluster_sg" {
  name        = local.msk_security_group_name
  description = "Rules for MSK cluster"
  vpc_id      = local.msk_vpc_id
  dynamic "ingress" {
    for_each = [
      for rules in local.msk_security_group_ingress_rules : rules
      if rules.enabled
    ]
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
