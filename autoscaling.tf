module "complete_lc" {
  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name            = "complete-asg-${var.environment}"
  use_name_prefix = false
  create_asg = true

  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch configuration
  lc_name   = "complete-lc-${var.environment}"
  use_lc    = true
  create_lc = true

  image_id          = data.aws_ami.amazon_linux.id
  instance_type     = "t3.micro"
# user_data         = local.user_data
  ebs_optimized     = true
  enable_monitoring = true

  iam_instance_profile_arn    = aws_iam_instance_profile.ssm.arn
  security_groups             = [module.security_group_ALB_id]
  associate_public_ip_address = true

# spot_price        = "0.014"
  target_group_arns = module.alb.target_group_arns

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      delete_on_termination = true
      encrypted             = true
      volume_type           = "gp2"
      volume_size           = "8"
    },
  ]

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = true
      volume_size           = "8"
      volume_type           = "gp2"
    },
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

#  tags        = local.tags
#  tags_as_map = local.tags_as_map
}