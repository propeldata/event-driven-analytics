# Event-driven Analytics with Propel

You've heard of [event-driven architecture (EDA)][eda]. How about event-driven
analytics? This project will show you

1. How to pipe events from your [Amazon EventBridge][eventbridge]-backed EDA
   into [Propel][propel].
2. How to build metrics on top of your events, suitable for inclusion in product
   dashboards.

We'll accomplish all of this following an [infrastructure as code (IaC)][iac]
approach with [Terraform][terraform] and [Propel's Terraform provider][provider].

## Choose your own adventure…

There are multiple ways to get data into Propel, and we have a guide for each:

* [HTTP](/http) — follow this if you want to publish data directly to Propel.
  This is the simplest way to get started.
* [S3](/s3) — follow this if you want to land data in an S3 bucket. This is
  great if you want to make you data available to other tools, not just Propel.
* [Snowflake](/snowflake) — follow this if you want to land data in your
  [Snowflake data warehouse][snowflake], optionally transforming the data using
  [dbt][dbt].

[eda]: https://en.wikipedia.org/wiki/Event-driven_architecture
[eventbridge]: https://aws.amazon.com/eventbridge/
[propel]: https://www.propeldata.com/
[iac]: https://en.wikipedia.org/wiki/Infrastructure_as_code
[terraform]: https://www.terraform.io/
[provider]: https://registry.terraform.io/providers/propeldata/propel/latest/docs
[snowflake]: https://www.snowflake.com/
[dbt]: https://www.getdbt.com/
