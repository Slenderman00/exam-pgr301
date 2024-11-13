if [ ! -f .env ]; then
    echo "Error: .env file not found"
    exit 1
fi

export $(cat .env | grep -v '^#' | xargs)

docker run -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
           -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
           -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-prod \
           prompttest:latest "man eating hotdogs"