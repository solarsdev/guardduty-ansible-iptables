//
// common layer
//

data "archive_file" "nodejs-common-layer" {
  type        = "zip"
  source_dir  = "../code/build/layer"
  output_path = "../code/output/layer.zip"
}

resource "aws_lambda_layer_version" "nodejs-common" {
  filename            = "../code/output/layer.zip"
  layer_name          = "${var.service_name_lowercase}-nodejs-common-layer"
  source_code_hash    = filebase64sha256("../code/output/layer.zip")
  compatible_runtimes = ["nodejs"]
}

//
// guarddutyFindingsTrigger
//

data "archive_file" "guardduty-findings-trigger-src" {
  type        = "zip"
  source_dir  = "../code/build/src/guarddutyFindingsTrigger"
  output_path = "../code/output/guarddutyFindingsTrigger.zip"
}

resource "aws_lambda_function" "guardduty-findings-trigger" {
  filename      = "../code/output/guarddutyFindingsTrigger.zip"
  function_name = "${var.service_name_lowercase}_guardduty-findings-trigger"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.nodejs-common.arn]
  runtime       = "nodejs14.x"

  source_code_hash = filebase64sha256("../code/output/guarddutyFindingsTrigger.zip")

  environment {
    variables = {
      TZ                = "Asia/Tokyo"
      SLACK_WEBHOOK_URL = var.SLACK_WEBHOOK_URL
    }
  }
}

//
// notify-command-result-to-slack
//

data "archive_file" "notify-command-result-to-slack-src" {
  type        = "zip"
  source_dir  = "../code/build/src/notifyCommandResultToSlack"
  output_path = "../code/output/notifyCommandResultToSlack.zip"
}

resource "aws_lambda_function" "notify-command-result-to-slack" {
  filename      = "../code/output/notifyCommandResultToSlack.zip"
  function_name = "${var.service_name_lowercase}_notify-command-result-to-slack"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.nodejs-common.arn]
  runtime       = "nodejs14.x"

  source_code_hash = filebase64sha256("../code/output/notifyCommandResultToSlack.zip")

  environment {
    variables = {
      TZ                = "Asia/Tokyo"
      SLACK_WEBHOOK_URL = var.SLACK_WEBHOOK_URL
    }
  }
}

resource "aws_lambda_permission" "default" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notify-command-result-to-slack.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.command-result.arn
}
