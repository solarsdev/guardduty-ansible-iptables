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
