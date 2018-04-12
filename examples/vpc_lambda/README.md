# example/vpc_lambda
========================

This example creates:
- One CloudWatchEvent
- Lambda VPC function
- IAM Role assigned to the lambda with the following policies attached: AWSLambdaBasicExecutionRole and AWSLambdaENIManagementAccess. In addition, additional policy is attached to read from a certain bucket. 
