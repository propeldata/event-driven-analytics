resource "propel_data_source" "all_events" {
  unique_name = "all_events"
  description = "Data Source for all events"

  connection_settings {
    account   = "${var.snowflake_account}.${var.snowflake_region}"
    database  = var.snowflake_database
    warehouse = var.snowflake_warehouse
    schema    = var.snowflake_schema
    role      = var.snowflake_role
    username  = var.snowflake_username
    password  = var.snowflake_password
  }
}

resource "propel_data_pool" "all_events" {
  unique_name = "all_events"
  description = "Data Pool for all events"
  data_source = propel_data_source.all_events.id

  table     = snowflake_table.all_events.name
  timestamp = "TIME"
}

resource "propel_metric" "all_events_metric" {
  unique_name = "all_events"
  description = "Metric for all events"
  data_pool   = propel_data_pool.all_events.id

  type = "COUNT"

  dimensions = [
    "VERSION",
    "DETAIL_TYPE",
    "SOURCE",
    "ACCOUNT",
    "REGION",
  ]
}
