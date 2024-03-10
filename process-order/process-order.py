import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    
    
    for record in event['Records']:
        order_id = json.loads(record['body'])['orderId']
        
        logger.info(f"Order ID: {order_id} has been processed")
        
    return{
        'statusCode':200,
        'body':json.dumps(event)
    }