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

resource "aws_kinesis_firehose_delivery_stream" "all_events" {
  name        = "all_events"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.all_events.arn
    bucket_arn         = aws_s3_bucket.all_events.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    # TODO(mroberts): We need to figure out how to get the table ID so that we
    #   can construct this URL dynamically. It should not be hardcoded.
    url            = "https://upload.us-east-2.propeldata.com/v1/TBLVR7QHY2PH605XKZ06W2085MGGM/events"
    name           = "Propel"
    role_arn       = aws_iam_role.all_events.arn
    s3_backup_mode = "FailedDataOnly"

    buffering_size     = 64
    buffering_interval = 60

    processing_configuration {
      enabled = true
      processors {
        type = "AppendDelimiterToRecord"
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
