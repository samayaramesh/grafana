data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

# resource "aws_network_interface" "this" {
#  count = 1

#  subnet_id = tolist(data.aws_subnet_ids.all.ids)[count.index]
# }

module "ec2_instance" {
 source = "terraform-aws-modules/ec2-instance/aws"
 name                        = "FCS-APP1-CAC1-${var.environment}"
 ami                         = data.aws_ami.amazon_linux.id
 instance_type              = var.instance_type
#  instance_count              = var.instance_count
 cpu_credits                 = "unlimited"
#  subnet_id                   = var.subnet_ids
 vpc_security_group_ids      = [module.security_group_ec2.security_group_id]
 iam_instance_profile        = aws_iam_instance_profile.grafana.name
 associate_public_ip_address = false
}

data "cloudinit_config" "conf" {
  gzip = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content = "baz"
    filename = "entry-script.sh"
  }
}