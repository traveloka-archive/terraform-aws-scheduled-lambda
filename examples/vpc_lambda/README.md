# example/vpc_lambda
========================

This example creates:
- One CloudWatchEvent
- Lambda VPC function
- IAM Role assigned to the lambda with the following policies attached: AWSLambdaBasicExecutionRole and AWSLambdaENIManagementAccess. In addition, additional policy is attached to read from a certain bucket. 

Usage
=====

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
