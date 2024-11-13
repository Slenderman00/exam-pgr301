- Task 1
    - Subtask A
        ```
        curl -X POST "https://ryx67kyki4.execute-api.eu-west-1.amazonaws.com/Prod/generate/" --data "man eating hotdogs"
        ```
    - Subtask B\
        [![Deploy SAM Application](https://github.com/Slenderman00/exam-pgr301/actions/workflows/deploy_sam_lambda.yaml/badge.svg)](https://github.com/Slenderman00/exam-pgr301/actions/workflows/deploy_sam_lambda.yaml)
- Task 2
    - Subtask A
        ```
        aws sqs send-message \
            --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-dev" \
            --message-body "man eating hotdogs" \
            --region eu-west-1 
        ```
    - Subtask B\
    [![Deploy Terraform Infrastructure](https://github.com/Slenderman00/exam-pgr301/actions/workflows/terraform_deploy.yml/badge.svg?branch=master)](https://github.com/Slenderman00/exam-pgr301/actions/workflows/terraform_deploy.yml)\
    The terraform plan can be found in the action summary in the form of two artifacts.\
    The following are two successful action runs: 
        - [dev branch](https://github.com/Slenderman00/exam-pgr301/actions/runs/11824576347)
        - [main branch](https://github.com/Slenderman00/exam-pgr301/actions/runs/11824548283)
- Task 3
    - Subtask A\
        The dockerfile can be found in the task3 directory.
    - Subtask B\
        [![Docker Build and Push](https://github.com/Slenderman00/exam-pgr301/actions/workflows/docker_build_push.yaml/badge.svg)](https://github.com/Slenderman00/exam-pgr301/actions/workflows/docker_build_push.yaml)\
        The Dockerhub repository can be found [here](https://hub.docker.com/repository/docker/slenderman00/testsqs):
        ```
        slenderman00/testsqs:sha-be23820
        ```
        The sqs url is: 
        ```
        https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-prod
        ```
        All images are tagged with the relevant git commit hash both the short and full version.\
        Semantic versioning was considered, but due to the amount of different projects in the same repository it would quickly get confusing
        with multiple sets of versions for the same repository.\
        With images tagged with hashes making it easy to check out the relevant commit.\
        The image can be tested by running:
        ```
        docker run \
            -e AWS_ACCESS_KEY_ID=xxx \
            -e AWS_SECRET_ACCESS_KEY=yyy \
            -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-prod \
            slenderman00/testsqs:sha-be23820 \
            "me on top of a pyramid"
        ```
- Task 4\
    The cloudwatch alert can be tested by, the alarm has been set to one minute:
    ```
    watch -n 1 'aws sqs send-message --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-prod" --message-body "A man eating hotdogs" --region eu-west-1'
    ```
    The alarm can be found under **63-queue-message-age-prod**