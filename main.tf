module "lambda_role" {
  source           = "github.com/traveloka/terraform-aws-iam-role.git//modules/service?ref=v0.2.0"
  aws_service      = "lambda.amazonaws.com"
  role_identifier  = "${var.lambda_name}"
  role_description = "Role for lambda ${var.lambda_name}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_role" {
  role       = "${module.lambda_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_eni_management" {
  role       = "${module.lambda_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  count      = "${var.is_vpc_lambda == "true" ? "1" : "0"}"
}

resource "aws_iam_role_policy" "lambda_additional_policy" {
  name   = "${var.lambda_name}"
  role   = "${module.lambda_role.role_name}"
  policy = "${var.iam_policy_document}"
  count  = "${length(var.iam_policy_document) > 0 ? 1 : 0}"
}

resource "random_id" "randomiser" {
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

resource "aws_lambda_function" "lambda_classic" {
  s3_bucket     = "${var.lambda_code_bucket}"
  s3_key        = "${var.lambda_code_path}"
  function_name = "${random_id.randomiser.hex}"
  description   = "${var.lambda_description}"
  role          = "${module.lambda_role.role_arn}"
  runtime       = "${var.lambda_runtime}"
  handler       = "${var.lambda_handler}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"

  tags = "${merge(local.default_tags, var.tags)}"

  environment = {
    variables = "${merge(var.environment_variables, map("ManagedBy", "Terraform"))}"
  }

  count = "${var.is_vpc_lambda == "true" ? "0" : "1"}"
}

resource "aws_lambda_function" "lambda_vpc" {
  s3_bucket     = "${var.lambda_code_bucket}"
  s3_key        = "${var.lambda_code_path}"
  function_name = "${random_id.randomiser.hex}"
  description   = "${var.lambda_description}"
  role          = "${module.lambda_role.role_arn}"
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

  count = "${var.is_vpc_lambda == "true" ? "1" : "0"}"
}

resource "aws_lambda_permission" "cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
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
  arn       = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
}
