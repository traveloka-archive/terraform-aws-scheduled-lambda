data "aws_iam_policy_document" "read-a-bucket" {
  statement {
    sid    = "AllowReadOfABucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::tools-infra-lambda-bucket/*",
    ]
  }
}

module "this" {
  source = "../../"

  lambda_code_bucket = "tools-infra-lambda-bucket"

  lambda_code_path = "dummy.zip"

  lambda_name = "GetInventory"

  lambda_runtime = "nodejs6.10"

  lambda_handler = "lib.default"

  lambda_memory_size = "128"

  lambda_timeout = "300"

  subnet_ids = ["subnet-9eb519e8"]

  security_group_ids = ["sg-17261b71", "sg-1f2b1679"]

  schedule_expression = "cron(*/2 * * * ? *)"

  iam_policy_document = ""

  environment = "staging"

  product_domain = "ti"

  tags = {
    service = "athbck"
  }

  is_vpc_lambda = "false"

  iam_policy_document = "${data.aws_iam_policy_document.read-a-bucket.json}"
}
