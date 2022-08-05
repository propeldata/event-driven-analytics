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
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.all_events.arn
    bucket_arn = aws_s3_bucket.all_events.arn

    prefix = "all_events"
  }
}

resource "aws_iam_role" "all_events" {
  name = "all_events"

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
  bucket = "51bc7e54-29cc-48a7-8d5a-527387530ede"
}

resource "aws_s3_bucket_acl" "all_events" {
  bucket = aws_s3_bucket.all_events.id
  acl    = "private"
}

resource "aws_sns_topic" "all_events" {
  name = "${aws_s3_bucket.all_events.bucket}-topic"

  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.all_events.arn}"}
        }
    }]
}
EOF
}

resource "aws_s3_bucket_notification" "all_events" {
  bucket = aws_s3_bucket.all_events.id

  topic {
    topic_arn = aws_sns_topic.all_events.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
