resource "propel_data_source" "all_events" {
  unique_name = "all_events"
  description = "Data Source for all events"
  type        = "S3"

  s3_connection_settings {
    bucket                = aws_s3_bucket.all_events.bucket
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
  }

  table {
    name = "all_events"
    path = "all_events/**/*.parquet"

    column {
      name     = "version"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "id"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "detail-type"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "source"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "account"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "time"
      type     = "TIMESTAMP"
      nullable = false
    }

    column {
      name     = "region"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "resources"
      type     = "STRING"
      nullable = true
    }

    column {
      name     = "detail"
      type     = "STRING"
      nullable = true
    }
  }
}

resource "propel_data_pool" "all_events" {
  unique_name = "all_events"
  description = "Data Pool for all events"
  data_source = propel_data_source.all_events.id

  table     = "all_events"
  timestamp = "time"
}

resource "propel_metric" "all_events" {
  unique_name = "all_events"
  description = "Metric for all events"
  data_pool   = propel_data_pool.all_events.id

  type = "COUNT"

  dimensions = ["version", "detail-type", "source", "account", "region"]
}
