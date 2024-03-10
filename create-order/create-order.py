import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    
    orderId = event['queryStringParameters']['orderId']

    jsonData = {
        "orderId" : orderId,
    }

    logger.info('## Input Parameters: %s', json.dumps(jsonData),)
    logger.info('## Input Parameters: %s', json.dumps(event),)

    client = boto3.client("sqs")
    response = client.send_message(
        QueueUrl="https://sqs.us-east-1.amazonaws.com/036745765136/sqs-order-process", 
        MessageBody=json.dumps(jsonData)
    )

    print(response)
    
    return {
        'statusCode': response["ResponseMetadata"]["HTTPStatusCode"],
        'body': json.dumps(response["ResponseMetadata"])
    }

       