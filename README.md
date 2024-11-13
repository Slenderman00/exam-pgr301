- Task 1
    - Subtask A
        ```
        curl -X POST "https://ryx67kyki4.execute-api.eu-west-1.amazonaws.com/Prod/generate/" --data "man bathing in hotdogs"
        ```
    - Subtask B\
        [![Deploy SAM Application](https://github.com/Slenderman00/exam-pgr301/actions/workflows/deploy_sam_lambda.yaml/badge.svg)](https://github.com/Slenderman00/exam-pgr301/actions/workflows/deploy_sam_lambda.yaml)
- Task 2
    - Subtask A\
        ```
        aws sqs send-message \
            --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-dev" \
            --message-body "man bathing in hotdogs" \
            --region eu-west-1 
        ```
    - Subtask B\
    [![Deploy Terraform Infrastructure](https://github.com/Slenderman00/exam-pgr301/actions/workflows/terraform_deploy.yml/badge.svg?branch=master)](https://github.com/Slenderman00/exam-pgr301/actions/workflows/terraform_deploy.yml)