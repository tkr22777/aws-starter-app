import json
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Process SQS messages from the queue.
    
    Args:
        event (dict): Contains information from the invoking service.
        context (object): Contains information about the invocation, function, and execution environment.
    
    Returns:
        dict: Response indicating successful processing
    """
    logger.info("Received event: %s", json.dumps(event))
    
    # Process each record (message) from SQS
    for record in event['Records']:
        # Extract the message body
        message_body = record['body']
        
        # Print the message body
        logger.info("Message body: %s", message_body)
        
        # If your message is in JSON format, you can parse and extract specific fields
        try:
            message_json = json.loads(message_body)
            logger.info("Parsed JSON message: %s", json.dumps(message_json, indent=2))
        except json.JSONDecodeError:
            logger.warning("Message body is not valid JSON. Processing as plain text.")
    
    logger.info("Successfully processed %d messages", len(event['Records']))
    return {
        'statusCode': 200,
        'body': json.dumps(f'Processed {len(event["Records"])} messages')
    } 