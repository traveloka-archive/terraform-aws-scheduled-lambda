variable "lambda_code_bucket" {
  type        = "string"
  description = "The name of the s3 bucket where the deployment resides"
}

variable "lambda_code_path" {
  type        = "string"
  description = "Name of the S3 Object that contains the function zip file"
}

variable "lambda_name" {
  type        = "string"
  description = "Lambda function name"
}

variable "lambda_description" {
  type        = "string"
  description = "Description of what the lambda does"
  default     = ""
}

variable "lambda_runtime" {
  type        = "string"
  description = "Runtime of the lambda"
}

variable "lambda_handler" {
  type        = "string"
  description = "Handler of the function"
}

variable "lambda_memory_size" {
  type        = "string"
  description = "Lambda memory size"
}

variable "lambda_timeout" {
  type        = "string"
  description = "Lambda timeout value"
}

variable "tags" {
  type        = "map"
  description = "Tags associated with the lambda"
  default     = {}
}

variable "environment_variables" {
  type        = "map"
  description = "Environment variables for the lambda"
  default     = {}
}

variable "iam_policy_document" {
  type        = "string"
  description = "Additional policy associated with the lambda"
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet ids associated with the lambda"
  default     = []
}

variable "security_group_ids" {
  type        = "list"
  description = "Security group ids associated with the lambda"
  default     = []
}

variable "schedule_expression" {
  type        = "string"
  description = "Cron expression to execute the lambda"
}

variable "environment" {
  type        = "string"
  description = "The environment where the lambda is running"
}

variable "product_domain" {
  type        = "string"
  description = "The product domain of the lambda"
}

variable "service_name" {
  type        = "string"
  description = "The service name of the lambda"
  default     = ""
}

variable "is_vpc_lambda" {
  type        = "string"
  description = "True of false to indicate whether this lambda is executed within VPC or not"
  default     = "true"
}
