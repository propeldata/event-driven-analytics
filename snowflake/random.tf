resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false

  keepers = {
    snowflake_account = "${var.snowflake_account}"
  }
}
