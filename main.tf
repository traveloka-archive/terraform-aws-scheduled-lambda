data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.lambda_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_role" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_eni_management" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${var.lambda_name}"
  role   = "${aws_iam_role.lambda.name}"
  policy = "${var.iam_policy_document}"
  count  = "${length(var.iam_policy_document) > 0 ? 1 : 0}"
}

resource "random_id" "randomiser" {
  keepers = {
    s3_key = "${var.lambda_code_path}"
  }

  byte_length = 8
  prefix      = "${var.product_domain}-${var.lambda_name}-"
}

locals {
  default_tags = {
    Name          = "${var.lambda_name}"
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
    Description   = "${var.lambda_description}"
    ManagedBy     = "Terraform"
  }
}

resource "aws_lambda_function" "lambda" {
  s3_bucket     = "${var.lambda_code_bucket}"
  s3_key        = "${var.lambda_code_path}"
  function_name = "${random_id.randomiser.hex}"
  description   = "${var.lambda_description}"
  role          = "${aws_iam_role.lambda.arn}"
  runtime       = "${var.lambda_runtime}"
  handler       = "${var.lambda_handler}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"

  tags = "${merge(local.default_tags, var.tags)}"

  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  environment = {
    variables = "${merge(var.environment_variables, map("ManagedBy", "Terraform"))}"
  }
}

resource "aws_lambda_permission" "cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
}

resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "${var.lambda_name}"
  description         = "Schedule trigger for lambda execution"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  target_id = "${var.lambda_name}"
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  arn       = "${aws_lambda_function.lambda.arn}"
}
