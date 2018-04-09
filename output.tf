output "lambda_arn" {
  value = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
}

output "role_arn" {
  value = "${aws_iam_role.lambda.*.arn}"
}
