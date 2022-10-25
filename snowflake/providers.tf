provider "aws" {}

provider "propel" {
  client_id     = var.propel_client_id
  client_secret = var.propel_client_secret
}

provider "random" {}

provider "snowflake" {
  account   = var.snowflake_account
  region    = var.snowflake_region
  username  = var.snowflake_username
  password  = var.snowflake_password
  role      = var.snowflake_role
}
