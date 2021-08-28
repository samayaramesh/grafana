provider "aws" {
  region = var.region
}
  tags_as_map = {

    Environment = "dev"
  }

  user_data = <<-EOT
  #!/bin/bash
  echo "Hello Terraform!"
  EOT
}