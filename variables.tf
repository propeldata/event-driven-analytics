variable "aws_access_key_id" {
  type        = string
  description = "Your AWS access key ID, used for setting up the Snowflake stage"
}

variable "aws_secret_access_key" {
  type        = string
  description = "Your AWS secret access key, used for setting up the Snowflake stage"
  sensitive   = true
}

variable "snowflake_account" {
  type        = string
  description = "Your Snowflake account"
}

variable "snowflake_region" {
  type        = string
  description = "Your Snowflake region"
}

variable "snowflake_username" {
  type        = string
  description = "Your Snowflake user's username"
}

variable "snowflake_password" {
  type        = string
  description = "Your Snowflake user's password"
  sensitive   = true
}

variable "snowflake_role" {
  type        = string
  description = "Your Snowflake user's role"
}

variable "snowflake_warehouse" {
  type        = string
  description = "Your Snowflake user's warehouse"
}

variable "snowflake_database" {
  type        = string
  description = "Your Snowflake database"
}

variable "snowflake_schema" {
  type        = string
  description = "Your Snowflake schema"
}
