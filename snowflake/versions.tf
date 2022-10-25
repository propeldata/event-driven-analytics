terraform {
  required_version = ">= 1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    propel = {
      source  = "propeldata/propel"
      version = "~> 0.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.36.0"
    }
  }
}
