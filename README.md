# [DEPRECATED] We are not maintaining this module anymore
# Please use https://github.com/traveloka/terraform-aws-lambda

# Scheduled AWS Lambda function
=============================

This module is used to provision AWS Lambda within VPC to run on a scheduled. This will create:
- One CloudWatchEvent
- Lambda function
- IAM Role assigned to the lambda with the following policies attached: AWSLambdaBasicExecutionRole and AWSLambdaENIManagementAccess. You could add other policy that the lambda needs.

Module Input Variables
----------------------

- `region` - Region where the lambda is deployed. The default is ap-southeast-1
- `lambda_code_bucket` - The name of the s3 bucket where the deployment resides
- `lambda_code_path` - Name of the S3 deployment object
- `lambda_name` - Unique name for Lambda function
- `lambda_runtime` - A [valid](http://docs.aws.amazon.com/cli/latest/reference/lambda/create-function.html#options) Lambda runtime environment
- `lambda_handler` - The entrypoint into your Lambda function
- `lambda_memory_size` - The memory size allocated to your lambda function
- `tags` - Tags associated with the lambda function
- `environment_variables` - Environment variables for your lambda function
- `iam_policy_document` - Additional IAM policy document to be attached to your lambda if the lambda needs to access another AWS resource.
- `schedule_expression` - a [valid rate or cron expression](http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html)
- `subnet_ids` - A list of subnet ids associated with the lambda
- `security_group_ids` - A list of security group ids associated with the lambda
- `is_vpc_lambda` - True if the lambda resides within VPC. False otherwise.

Usage 
-----
Please look at the complete example.

Outputs
-------
- `lambda_arn` - ARN for the created Lambda function.
- `role_arn` - ARN of the IAM role assigned to the lambda.

Author
------
- [Oktaviandi Hadi Nugraha](https://github.com/oktaviandi-nugraha)
