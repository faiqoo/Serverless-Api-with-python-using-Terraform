data "archive_file" "process_order_lambda" {
  type = "zip"

  source_dir  = "${path.module}/process-order"
  output_path = "${path.module}/process-order.zip"
}

resource "aws_s3_object" "process_order_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "process-order.zip"
  source = data.archive_file.process_order_lambda.output_path

  etag = filemd5(data.archive_file.process_order_lambda.output_path)
}


resource "aws_lambda_function" "process_order_func_lambda" {
  function_name = "ProcessOrder"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.process_order_lambda.key

  runtime = "python3.10"
  handler = "process-order.lambda_handler"

  source_code_hash = data.archive_file.process_order_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec_2.arn
}

resource "aws_cloudwatch_log_group" "process_order_func_lambda" {
  name = "/aws/lambda/${aws_lambda_function.process_order_func_lambda.function_name}"

  retention_in_days = 14
}

resource "aws_iam_role" "lambda_exec_2" {
  name = "serverless_lambda_2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_2" {
  role       = aws_iam_role.lambda_exec_2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Attachment of a Managed AWS IAM Policy for Lambda sqs execution
resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_queue_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  role       = aws_iam_role.lambda_exec_2.name
}

