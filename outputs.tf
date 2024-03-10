# Output value definitions

output "endpoint_url" {
value="${aws_api_gateway_stage.rest.invoke_url}/${var.endpoint_path}?orderId=123"
}

output "SQSqueueARN" {
  value       = aws_sqs_queue.sqs_queue.arn
  description = "SQS queue ARN"
}

output "SQSqueueURL" {
  value       = aws_sqs_queue.sqs_queue.url
  description = "SQS queue URL"
}

# output "lambda_bucket_name" {
#   description = "Name of the S3 bucket used to store function code."

#   value = aws_s3_bucket.lambda_bucket.id
# }

