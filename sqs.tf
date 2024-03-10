resource "aws_sqs_queue" "sqs_queue" {
    name = "sqs-order-process"

}


#Call SQS resource as data reference after creating queue
data "aws_sqs_queue" "sqs_queue" {
    name = "sqs-order-process"
}

resource "aws_lambda_event_source_mapping" "lambda_test_sqs_trigger" {
  event_source_arn = data.aws_sqs_queue.sqs_queue.arn
  function_name    = aws_lambda_function.process_order_func_lambda.arn
  depends_on       = [aws_sqs_queue.sqs_queue]

}
