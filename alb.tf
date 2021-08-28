module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name_prefix = "FCS-APP1-CAC1-${var.environment}-"

  load_balancer_type = "application"

  vpc_id             = data.aws_vpc.default.id
  subnet_id          = data.aws_subnet_ids.all.ids
  security_groups    = module.security_group_alb.security_group_id

  access_logs = {
    bucket = module.s3_bucket_alb_logs_s3_bucket_id
  }

  target_groups = [
    {
      name_prefix      = "FCS-APP1-CAC1-${var.environment}-"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      targets = [
        {
          target_id = module.ec2_instance.ec2_instance_id
          port = 80
        },
        {
          target_id = module.ec2_instance.ec2_instance_id
          port = 8080
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = var.environment
  }
}