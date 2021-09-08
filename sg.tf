module "security_group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name                = "FCS-APP1-CAC1"
  description         = "Security group for ALB"
  vpc_id              = var.cidr_blocks
  ingress_cidr_blocks = [var.app_cidr_blocks]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "security_group_ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name               = "FCS-APP1-CAC1"
  description         = "Security group for EC2 instance"
  vpc_id              = var.cidr_blocks
  ingress_cidr_blocks = [var.app_cidr_blocks, var.cidr_blocks]
  # ingress_rules       = ["ssh-22-tcp", "all-icmp"]
  ingress_rules = ["https-443-tcp", "http-80-tcp", "ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.security_group_alb.security_group_id
    },
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}