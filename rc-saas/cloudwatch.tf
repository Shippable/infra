resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api" {
  alarm_name = "alarm_avg_latency_api"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "1"
  evaluation_periods = "1"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${local.lb_api_name}"
  }

  alarm_description = "Monitors average latency on the API ELB"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api_int" {
  alarm_name = "alarm_avg_latency_api_int"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "1"
  evaluation_periods = "1"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${local.lb_api_int_name}"
  }

  alarm_description = "Monitors average latency on the INT API ELB"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api_con" {
  alarm_name = "alarm_avg_latency_api_con"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "1"
  evaluation_periods = "1"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${local.lb_api_con_name}"
  }

  alarm_description = "Monitors average latency on the CON API ELB"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}
