resource "aws_sns_topic" "command-result" {
  name = "${var.service_name_lowercase}-command-result-sns"

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.command-result.sns"
  })
}

resource "aws_sns_topic_subscription" "command-result-to-slack" {
  topic_arn = aws_sns_topic.command-result.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.notify-command-result-to-slack.arn
}
