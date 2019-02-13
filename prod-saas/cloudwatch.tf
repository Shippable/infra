resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api" {
  count = "${length(local.all_pub_api_elb_names)}"
  alarm_name = "alarm_avg_latency_${element(local.all_pub_api_elb_names, count.index)}"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "0.200"
  evaluation_periods = "4"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${element(local.all_pub_api_elb_names, count.index)}"
  }

  alarm_description = "Monitors average latency on ${element(local.all_pub_api_elb_names, count.index)}"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}


resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api_int" {
  count = "${length(local.all_int_api_elb_names)}"
  alarm_name = "alarm_avg_latency_${element(local.all_int_api_elb_names, count.index)}"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "0.100"
  evaluation_periods = "4"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${element(local.all_int_api_elb_names, count.index)}"
  }

  alarm_description = "Monitors average latency on ${element(local.all_int_api_elb_names, count.index)}"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}


resource "aws_cloudwatch_metric_alarm" "alarm_avg_latency_api_con" {
  count = "${length(local.all_con_api_elb_names)}"
  alarm_name = "alarm_avg_latency_${element(local.all_con_api_elb_names, count.index)}"
  metric_name = "Latency"
  comparison_operator = "GreaterThanThreshold"
  threshold = "0.200"
  evaluation_periods = "4"
  namespace = "AWS/ELB"
  period = "60"
  statistic = "Average"

  dimensions {
    LoadBalancerName = "${element(local.all_con_api_elb_names, count.index)}"
  }

  alarm_description = "Monitors average latency on ${element(local.all_con_api_elb_names, count.index)}"
  alarm_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
  ok_actions = ["${aws_sns_topic.topic_cloudwatch_alert.arn}"]
}
