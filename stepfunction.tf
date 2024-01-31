resource "aws_sfn_state_machine" "appstream_autoscale_state_machine" {
  name     = "appstream_autoscaling_state_machine"
  role_arn = aws_iam_role.steps_execution_role.arn
  type     = "STANDARD"

  definition = <<EOF
{
  "Comment": "State machine for Appstream autoscaling",
  "StartAt": "Choice",
  "States": {
    "Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.state",
          "StringEquals": "Weekday_Peak",
          "Next": "DisableWeekend"
        },
        {
          "Variable": "$.state",
          "StringEquals": "Weekday_Off_Peak",
          "Next": "DisableWeekdayPeak"
        },
        {
          "Variable": "$.state",
          "StringEquals": "Off_Peak_Weekend",
          "Next": "DisableWeekday"
        }
      ]
    },
    "DisableWeekend": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[1].alarm_name}",
          "${local.cloudwatch_alarms[2].alarm_name}",
          "${local.cloudwatch_alarms[4].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:disableAlarmActions",
      "Next": "EnablePeakWeekday"
    },
    "EnablePeakWeekday": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[0].alarm_name}",
          "${local.cloudwatch_alarms[3].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:enableAlarmActions",
      "End": true
    },
    "DisableWeekdayPeak": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[0].alarm_name}",
          "${local.cloudwatch_alarms[2].alarm_name}",
          "${local.cloudwatch_alarms[3].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:disableAlarmActions",
      "Next": "EnableWeekdayOffPeak"
    },
    "EnableWeekdayOffPeak": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[1].alarm_name}",
          "${local.cloudwatch_alarms[4].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:enableAlarmActions"
    },
    "DisableWeekday": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[0].alarm_name}",
          "${local.cloudwatch_alarms[1].alarm_name}",
          "${local.cloudwatch_alarms[3].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:disableAlarmActions",
      "Next": "EnableWeekend"
    },
    "EnableWeekend": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[2].alarm_name}",
          "${local.cloudwatch_alarms[4].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:enableAlarmActions"
    }
  }
}
EOF
}