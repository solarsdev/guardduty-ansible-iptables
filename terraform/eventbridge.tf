
resource "aws_cloudwatch_event_rule" "guardduty-trigger" {
  name        = "${var.service_name_lowercase}.guardduty-trigger.event-rule"
  description = "Triggerd when GuardDuty findings are detected"

  event_pattern = jsonencode({
    "source"      = ["aws.guardduty"]
    "detail-type" = ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "guardduty-trigger-lambda" {
  rule = aws_cloudwatch_event_rule.guardduty-trigger.name
  arn  = aws_lambda_function.guardduty-findings-trigger.arn
}
