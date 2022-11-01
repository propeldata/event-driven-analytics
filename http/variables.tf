variable "propel_client_id" {
  type        = string
  description = "Your Propel' Application's client ID (must have \"admin\" scope)"
}

variable "propel_client_secret" {
  type        = string
  description = "Your Propel' Application's client secret (must have \"admin\" scope)"
  sensitive   = true
}
