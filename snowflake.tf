resource "snowflake_table" "all_events" {
  database = var.snowflake_database
  schema   = var.snowflake_schema
  name     = "ALL_EVENTS"

  change_tracking = true

  column {
    name     = "VERSION"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "ID"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "DETAIL_TYPE"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "SOURCE"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "ACCOUNT"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "TIME"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = false
  }

  column {
    name     = "REGION"
    type     = "VARCHAR(16777216)"
    nullable = false
  }

  column {
    name     = "RESOURCES"
    type     = "ARRAY"
    nullable = false
  }

  column {
    name     = "DETAIL"
    type     = "OBJECT"
    nullable = false
  }
}

resource "snowflake_stage" "all_events" {
  database    = var.snowflake_database
  schema      = var.snowflake_schema
  name        = "ALL_EVENTS"

  url         = "s3://${aws_s3_bucket.all_events.bucket}/all_events"
  credentials = "AWS_KEY_ID='${var.aws_access_key_id}' AWS_SECRET_KEY='${var.aws_secret_access_key}'"
}

resource "snowflake_pipe" "all_events" {
  database = var.snowflake_database
  schema   = var.snowflake_schema
  name     = "ALL_EVENTS"

  copy_statement = <<EOF
COPY INTO ${var.snowflake_database}.${var.snowflake_schema}.${snowflake_table.all_events.name} FROM (SELECT
  $1['version']::VARCHAR,
  $1['id']::VARCHAR,
  $1['detail-type']::VARCHAR,
  $1['source']::VARCHAR,
  $1['account']::VARCHAR,
  $1['time']::TIMESTAMP_NTZ,
  $1['region']::VARCHAR,
  PARSE_JSON($1['resources']::VARCHAR)::ARRAY,
  PARSE_JSON($1['detail']::VARCHAR)::OBJECT
FROM @${var.snowflake_database}.${var.snowflake_schema}.${snowflake_stage.all_events.name}) FILE_FORMAT = (TYPE = PARQUET)
EOF

  auto_ingest = true
}
