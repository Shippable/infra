resource "aws_sns_topic" "topic_cloudwatch_alert" {
  name = "topic_cloudwatch_alert"
}

resource "aws_sns_topic_subscription" "subscription_cloudwatch_alert_lambda" {
  topic_arn = "${aws_sns_topic.topic_cloudwatch_alert.arn}"
  protocol = "lambda"
  endpoint = "${aws_lambda_function.lambda_cloudwatch_to_slack.arn}"
}

resource "aws_lambda_permission" "lambda_permission_allow_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda_cloudwatch_to_slack.arn}"
    principal = "sns.amazonaws.com"
    source_arn = "${aws_sns_topic.topic_cloudwatch_alert.arn}"
}
