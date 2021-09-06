module "security_group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name                = "FCS-APP1-CAC1-${var.environment}-ALBSG"
  description         = "Security group for ALB"
  vpc_id              = data.aws_vpc.default.id
  ingress_cidr_blocks = [var.app_cidr_blocks]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [var.app_cidr_blocks]
  # }

  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = [var.app_cidr_blocks]
  # }

  # ingress {
  #   from_port = 8
  #   to_port = 0
  #   protocol    = "icmp"
  #   cidr_blocks = [var.app_cidr_blocks]
  # }

  # egress {
  #   from_port       = 0
  #   to_port         = 0
  #   protocol        = "-1"
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }

  # egress {
  #   from_port = 0
  #   to_port = 0
  #   protocol = "-1"
  #   ipv6_cidr_blocks = ["::/0"]
  # }
}

module "security_group_ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name                = "FCS-APP1-CAC1-${var.environment}-EC2SG"
  description         = "Security group for EC2 instance"
  vpc_id              = data.aws_vpc.default.id
  ingress_cidr_blocks = [var.app_cidr_blocks, var.cidr_blocks]
  ingress_rules       = ["ssh-22-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = ["http-80-tcp"]
      source_security_group_id = module.security_group_alb.security_group_id
    },
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [
#       var.app_cidr_blocks, var.cidr_blocks]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     security_groups = [
#       module.security_group_alb.security_group_id]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     security_groups = [
#       module.security_group_alb.security_group_id]
#   }

#   ingress {
#     from_port = 8
#     to_port = 0
#     protocol    = "icmp"
#     cidr_blocks = [var.cidr_blocks]
#   }

#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     ipv6_cidr_blocks = ["::/0"]
#   }