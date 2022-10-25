resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false

  keepers = {
    aws_access_key_id = "${var.aws_access_key_id}"
  }
}
