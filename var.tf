variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "accountId" {
description =  "The AWS account ID"
type = string
}


variable "lambda_function_name" {
description = "What to name the lambda function"
type = string
default = "Currency_Converter"
}

variable "endpoint_path"{
   description = "The GET endpoint path"
type = string
default =  "createOrder"
}
