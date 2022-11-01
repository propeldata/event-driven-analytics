provider "aws" {}

provider "propel" {
  client_id     = var.propel_client_id
  client_secret = var.propel_client_secret
}

provider "random" {}
