#!/bin/bash
QUEUE_URL="https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-dev"

send_message() {
    echo "Sending message to queue..."
    aws sqs send-message \
        --queue-url "$QUEUE_URL" \
        --message-body "Generate an image of a majestic mountain landscape with snow peaks" \
        --region eu-west-1
    
    echo "Message sent!"
}

receive_messages() {
    echo "Checking for messages..."
    aws sqs receive-message \
        --queue-url "$QUEUE_URL" \
        --max-number-of-messages 10 \
        --region eu-west-1 \
        --wait-time-seconds 5

    echo "Message check complete!"
}

echo "=== Test Lambda SQS Setup ==="

echo "Queue URL: $QUEUE_URL"
echo

echo "1. Sending test message"
send_message
echo

echo "2. Waiting 5 seconds for processing..."
sleep 5
echo

echo "3. Checking for messages"
receive_messages
echo

echo -e "\n=== Test Complete ==="