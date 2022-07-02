data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role" "lambda" {
  name = "${var.service_name_lowercase}.lambda.iam"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn, data.aws_iam_policy.AmazonS3FullAccess.arn]
}

resource "aws_iam_role" "ssm-instance" {
  name = "${var.service_name_lowercase}.ssm-instance.iam"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn, data.aws_iam_policy.AmazonS3FullAccess.arn]
}

resource "aws_iam_instance_profile" "control" {
  name = "${var.service_name_lowercase}.control.instance-profile"
  role = aws_iam_role.ssm-instance.name
}

data "aws_iam_policy_document" "sns-publish" {
  statement {
    actions = [
      "sns:Publish"
    ]
    effect    = "Allow"
    resources = ["*"] # arn: SNS
  }
}

resource "aws_iam_role" "sns-publish" {
  name = "${var.service_name_lowercase}.sns-publish.iam"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = ["ssm.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "sns-publish"
    policy = data.aws_iam_policy_document.sns-publish.json
  }
}
