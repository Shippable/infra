resource "aws_lambda_function" "lambda_cloudwatch_to_slack" {

  function_name = "cloudwatch_to_slack"
  role = "${aws_iam_role.role_lambda_basic_execute.arn}"
  handler = "index.handler"
  runtime = "nodejs8.10"

  s3_bucket = "${var.cloudwatch_slack_lambda_s3_bucket}"
  s3_key = "${var.cloudwatch_slack_lambda_s3_key}"
  s3_object_version = "${var.cloudwatch_slack_lambda_s3_object_version}"


  environment {
    variables = {
      hookUrl = "${var.cloudwatch_slack_hook_url}"
      slackChannel = "${var.cloudwatch_slack_channel}"
    }
  }
}
