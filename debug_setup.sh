#!/bin/bash

QUEUE_URL="https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-dev"
FUNCTION_NAME="63-image-generator-dev"
REGION="eu-west-1"

echo "=== Debugging Lambda SQS Setup ==="

echo -e "\n1. Checking Lambda Function..."
aws lambda get-function \
    --function-name $FUNCTION_NAME \
    --region $REGION

echo -e "\n2. Checking Lambda Role and Permissions..."
ROLE_ARN=$(aws lambda get-function \
    --function-name $FUNCTION_NAME \
    --region $REGION \
    --query 'Configuration.Role' \
    --output text)
aws iam get-role --role-name $(echo $ROLE_ARN | cut -d/ -f2)

echo -e "\n3. Checking Event Source Mapping..."
aws lambda list-event-source-mappings \
    --function-name $FUNCTION_NAME \
    --region $REGION

echo -e "\n4. Recent CloudWatch Logs..."
LOG_GROUP="/aws/lambda/$FUNCTION_NAME"

LOG_STREAM=$(aws logs describe-log-streams \
    --log-group-name $LOG_GROUP \
    --region $REGION \
    --order-by LastEventTime \
    --descending \
    --limit 1 \
    --query 'logStreams[0].logStreamName' \
    --output text)

if [ $? -eq 0 ] && [ "$LOG_STREAM" != "None" ]; then
    aws logs get-log-events \
        --log-group-name $LOG_GROUP \
        --log-stream-name "$LOG_STREAM" \
        --region $REGION
else
    echo "No log streams found or CloudWatch Logs group doesn't exist"
fi

echo -e "\n5. Testing SQS Queue..."
aws sqs send-message \
    --queue-url $QUEUE_URL \
    --message-body "Generate an image of a sunset over mountains" \
    --region $REGION

echo -e "\n6. Waiting 10 seconds and checking queue..."
sleep 10
aws sqs receive-message \
    --queue-url $QUEUE_URL \
    --region $REGION \
    --max-number-of-messages 10

echo -e "\n=== Debug Complete ==="

echo -e "\nTo check logs in AWS Console, go to:"
echo "https://$REGION.console.aws.amazon.com/cloudwatch/home?region=$REGION#logsV2:log-groups/log-group/$LOG_GROUP"