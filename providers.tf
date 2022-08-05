provider "aws" {}

provider "snowflake" {
  account   = var.snowflake_account
  region    = var.snowflake_region
  username  = var.snowflake_username
  password  = var.snowflake_password
  role      = var.snowflake_role
}
