variable "environment" {}
variable "instance_type" {}
variable "cidr_blocks" {}
variable "app_cidr_blocks" {}
# variable "application" {}
# variable "customer" {}
# variable "s3_bucket" {}
variable "instance_count" {}
# variable "private_key" {}
variable "key_name" {}
variable "region" {}
variable "subnet_ids" {
  type        = list(string)
  default     = []
}