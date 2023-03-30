resource "propel_data_source" "all_events" {
  unique_name = "all_events"
  description = "Data Source for all events"
  type        = "Http"

  table {
    name = "all_events"

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
      name     = "detail"
      type     = "JSON"
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
  }
}

resource "propel_data_pool" "all_events" {
  unique_name = "all_events"
  description = "Data Pool for all events"
  data_source = propel_data_source.all_events.id

  table     = "all_events"
  timestamp = "time"

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
    name     = "detail"
    type     = "JSON"
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
}

resource "propel_metric" "all_events" {
  unique_name = "all_events"
  description = "Metric for all events"
  data_pool   = propel_data_pool.all_events.id

  type = "COUNT"

  dimensions = ["version", "detail", "detail-type", "source", "account", "region"]
}
