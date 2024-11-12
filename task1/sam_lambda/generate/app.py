import base64
import boto3
import json
import random
import os


def generate_image(prompt):
    bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
    s3_client = boto3.client("s3")

    # Define the model ID
    model_id = "amazon.titan-image-generator-v1"

    bucket_name = os.getenv("BUCKET_NAME")
    image_path = os.getenv("IMAGE_PATH")

    seed = random.randint(0, 2147483647)
    s3_image_path = f"{image_path}/titan_{seed}.png"

    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        },
    }

    response = bedrock_client.invoke_model(
        modelId=model_id, body=json.dumps(native_request)
    )
    model_response = json.loads(response["body"].read())

    # Extract and decode the Base64 image data
    base64_image_data = model_response["images"][0]
    image_data = base64.b64decode(base64_image_data)

    # Upload the decoded image data to S3
    s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

    image_url = f"https://{bucket_name}.s3.amazonaws.com/{s3_image_path}"
    return image_url


def lambda_handler(event, context):
    """Sample pure Lambda function

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format

        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    API Gateway Lambda Proxy Output Format: dict

        Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    """

    # try:
    #     ip = requests.get("http://checkip.amazonaws.com/")
    # except requests.RequestException as e:
    #     # Send some context about this error to Lambda Logs
    #     print(e)

    #     raise e

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "image": generate_image(event["body"]),
            }
        ),
    }
