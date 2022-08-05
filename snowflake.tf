resource "snowflake_table" "all_events" {
  database = var.snowflake_database
  schema   = var.snowflake_schema
  name     = "all_events"

  change_tracking = true

  column {
    name     = "version"
    type     = "text"
    nullable = false
  }

  column {
    name     = "id"
    type     = "text"
    nullable = false
  }

  column {
    name     = "detail-type"
    type     = "text"
    nullable = false
  }

  column {
    name     = "source"
    type     = "text"
    nullable = false
  }

  column {
    name     = "account"
    type     = "text"
    nullable = false
  }

  column {
    name     = "time"
    type     = "text"
    nullable = false
  }

  column {
    name     = "region"
    type     = "text"
    nullable = false
  }

  column {
    name     = "resources"
    type     = "array"
    nullable = false
  }

  column {
    name     = "detail"
    type     = "object"
    nullable = "false"
  }
}

resource "snowflake_stage" "all_events" {
  database    = var.snowflake_database
  schema      = var.snowflake_schema
  name        = "all_events"

  url         = "s3://${aws_s3_bucket.all_events.bucket}/all_events"
  credentials = "AWS_KEY_ID='${var.aws_access_key_id}' AWS_SECRET_KEY='${var.aws_secret_access_key}'"
}

resource "snowflake_pipe" "all_events" {
  database = var.snowflake_database
  schema   = var.snowflake_schema
  name     = "all_events"

  copy_statement = "copy into ${snowflake_table.all_events.name} from @${snowflake_stage.all_events.name}"

  auto_ingest       = true
  aws_sns_topic_arn = aws_sns_topic.all_events.arn
}
