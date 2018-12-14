resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api" {
  count = 3
  alarm_name = "alarm_avg_latency_${element(local.api_lb_names, count.index)}"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "1"
  evaluation_periods = "1"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${element(local.api_lb_names, count.index)}"
  }

  alarm_description = "Monitors average latency on ${element(local.api_lb_names, count.index)}"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}
