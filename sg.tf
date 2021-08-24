module "security_group_ALB" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name_prefix         = "FCS-APP1-CAC1-${var.environment}-ALB-SG-GRAFANA"
  description         = "Security group for ALB"
  vpc_id              = data.aws_vpc.default.id
  ingress_cidr_blocks = [var.app_cidr_blocks]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

module "security_group_ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name_prefix         = "FCS-APP1-CAC1-${var.environment}-SG-GRAFANA"
  description         = "Security group for EC2 instance"
  vpc_id              = data.aws_vpc.default.id
  ingress_cidr_blocks = [var.app_cidr_blocks, var.cidr_blocks]
  ingress_rules       = ["ssh-22-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = ["http-80-tcp", "https-443-tcp"]
      source_security_group_id = module.security_group_ALB.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
}