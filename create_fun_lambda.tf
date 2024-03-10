data "archive_file" "create_order_lambda" {
  type = "zip"

  source_dir  = "${path.module}/create-order"
  output_path = "${path.module}/create-order.zip"
}


resource "aws_s3_object" "create_order_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "create-order.zip"
  source = data.archive_file.create_order_lambda.output_path

  etag = filemd5(data.archive_file.create_order_lambda.output_path)
}


resource "aws_lambda_function" "create_order_func_lambda" {
  function_name = "CreateOrder"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.create_order_lambda.key

  runtime = "python3.10"
  handler = "create-order.lambda_handler"

  source_code_hash = data.archive_file.create_order_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec_1.arn

  environment {
    variables = {
      SQSqueueName = aws_sqs_queue.sqs_queue.url
    }
  }

}

resource "aws_cloudwatch_log_group" "create_order_func_lambda" {
  name = "/aws/lambda/${aws_lambda_function.create_order_func_lambda.function_name}"

  retention_in_days = 14
}

resource "aws_iam_role" "lambda_exec_1" {
  name = "serverless_lambda_1"

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
  inline_policy {
    name   = "policy-8675309"
    policy = data.aws_iam_policy_document.lambda_policy_document.json
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_1" {
  role       = aws_iam_role.lambda_exec_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}


data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
  
    effect = "Allow"
  
    actions = [
      "sqs:*"
    ]

    resources = [
      aws_sqs_queue.sqs_queue.arn,
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda_policy"
  path        = "/"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
  lifecycle {
    create_before_destroy = true
  }
}

