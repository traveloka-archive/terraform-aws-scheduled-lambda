output "lambda_arn" {
  value = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
}

output "role_arn" {
  value       = "${module.lambda_role.role_arn}"
  description = "The arn of the role assigned to the lambda"
}
