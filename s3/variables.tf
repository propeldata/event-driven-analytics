variable "aws_access_key_id" {
  type        = string
  description = "Your AWS access key ID, used for setting up the S3 Data Source"
}

variable "aws_secret_access_key" {
  type        = string
  description = "Your AWS secret access key, used for setting up the S3 Data Source"
  sensitive   = true
}

variable "propel_client_id" {
  type        = string
  description = "Your Propel' Application's client ID (must have \"admin\" scope)"
}

variable "propel_client_secret" {
  type        = string
  description = "Your Propel' Application's client secret (must have \"admin\" scope)"
  sensitive   = true
}
