locals {

  common_alarms = {
    evaluation_periods  = 1
    metric_name         = "AvailableCapacity"
    namespace           = "AWS/AppStream"
    statistic           = "Maximum"
    period              = 300
    dimensions = {
      Fleet = var.fleet_name
    }
  }

  cloudwatch_alarms = [
    {
      alarm_name          = "appstream_scale_out_weekday_peak"
      comparison_operator = "LessThanThreshold"
      threshold           = var.scale_out_weekday.peak_threshold
      alarm_description   = "Scale up AppStream fleet when available capacity is below ${var.scale_out_weekday.peak_threshold}."
      alarm_actions       = [aws_appautoscaling_policy.appstream_scaling_policy_up[1].arn]
    },
    {
      alarm_name          = "appstream_scale_out_weekday_off_peak"
      comparison_operator = "LessThanThreshold"
      threshold           = var.scale_out_weekday.offpeak_threshold
      alarm_description   = "Scale up AppStream fleet when available capacity is below ${var.scale_out_weekday.offpeak_threshold}."
      alarm_actions       = [aws_appautoscaling_policy.appstream_scaling_policy_up[2].arn]
    },
    {
      alarm_name          = "appstream_scale_out_weekend"
      comparison_operator = "LessThanThreshold"
      threshold           = var.scale_out_weekend.threshold
      alarm_description   = "Scale up AppStream fleet when available capacity is below ${var.scale_out_weekend.threshold}."
      alarm_actions       = [aws_appautoscaling_policy.appstream_scaling_policy_up[0].arn]
    },
    {
      alarm_name          = "appstream_scale_in_peak"
      comparison_operator = "GreaterThanThreshold"
      threshold           = var.scale_in_peak.threshold
      alarm_description   = "Scale down AppStream fleet when available capacity is above ${var.scale_in_peak.threshold}."
      alarm_actions       = [aws_appautoscaling_policy.appstream_scaling_policy_down[0].arn]
    },
    {
      alarm_name          = "appstream_scale_in_off_peak"
      comparison_operator = "GreaterThanThreshold"
      threshold           = var.scale_in_offpeak.threshold
      alarm_description   = "Scale down AppStream fleet when available capacity is above ${var.scale_in_offpeak.threshold}."
      alarm_actions       = [aws_appautoscaling_policy.appstream_scaling_policy_down[1].arn]
    },
  ]
}

resource "aws_cloudwatch_metric_alarm" "scaling_alarm" {
  count = length(local.cloudwatch_alarms)

  alarm_name          = local.cloudwatch_alarms[count.index].alarm_name
  comparison_operator = local.cloudwatch_alarms[count.index].comparison_operator
  evaluation_periods  = local.common_alarms.evaluation_periods
  metric_name         = local.common_alarms.metric_name
  namespace           = local.common_alarms.namespace
  period              = local.common_alarms.period
  statistic           = local.common_alarms.statistic
  threshold           = local.cloudwatch_alarms[count.index].threshold
  dimensions          = local.common_alarms.dimensions
  alarm_description   = local.cloudwatch_alarms[count.index].alarm_description
  alarm_actions       = local.cloudwatch_alarms[count.index].alarm_actions
  actions_enabled     = false
}
