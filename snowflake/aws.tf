module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  attach_kinesis_firehose_policy = true
  kinesis_firehose_target_arns   = [aws_kinesis_firehose_delivery_stream.all_events.arn]

  append_rule_postfix = false

  rules = {
    all_events = {
      description   = "Capture all events"
      event_pattern = jsonencode({ "source": [{"prefix": "" }] })
      enabled       = true
    }
  }

  targets = {
    all_events = [
      {
        name            = "send-all-events-to-kinesis"
        arn             = aws_kinesis_firehose_delivery_stream.all_events.arn
        attach_role_arn = true
      }
    ]
  }
}

resource "aws_glue_catalog_database" "all_events" {
  name = "all_events"
}

resource "aws_glue_catalog_table" "all_events" {
  database_name = aws_glue_catalog_database.all_events.name
  name          = "all_events"

  storage_descriptor {
    columns {
      name = "version"
      type = "string"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "detail-type"
      type = "string"
    }

    columns {
      name = "source"
      type = "string"
    }

    columns {
      name = "account"
      type = "string"
    }

    columns {
      name = "time"
      type = "timestamp"
    }

    columns {
      name = "region"
      type = "string"
    }

    columns {
      name = "resources"
      type = "string"
    }

    columns {
      name = "detail"
      type = "string"
    }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "all_events" {
  name        = "all_events"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.all_events.arn
    bucket_arn = aws_s3_bucket.all_events.arn

    prefix = "all_events/"

    buffer_size     = 64
    buffer_interval = 60

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }
      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }
      schema_configuration {
        database_name = aws_glue_catalog_database.all_events.name
        table_name    = aws_glue_catalog_table.all_events.name
        role_arn      = aws_iam_role.all_events.arn
      }
    }
  }
}

resource "aws_iam_role" "all_events" {
  name = "all_events"

  inline_policy {
    name = "kinesis-firehose-policy"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.all_events.arn}",
        "${aws_s3_bucket.all_events.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "glue:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "all_events" {
  bucket = "all-events-${random_string.suffix.result}"
}

resource "aws_s3_bucket_acl" "all_events" {
  bucket = aws_s3_bucket.all_events.id
  acl    = "private"
}

resource "aws_s3_bucket_notification" "all_events" {
  bucket = aws_s3_bucket.all_events.bucket

  queue {
    queue_arn = snowflake_pipe.all_events.notification_channel
    events    = ["s3:ObjectCreated:*"]
  }
}
