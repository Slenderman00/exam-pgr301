- Task 1
    - Subtask A
        ```
        curl -X POST \
            "https://ryx67kyki4.execute-api.eu-west-1.amazonaws.com/Prod/generate/" \
            --data "man eating hotdogs"
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
        slenderman00/testsqs
        ```
        The sqs url is: 
        ```
        https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-prod
        ```
        The latest image is tagged with latest as expected.\
        All images are tagged with the relevant git commit hash both the short and full version.\
        Semantic versioning was considered, but due to the amount of different projects in the same repository it would quickly get confusing
        with multiple sets of versions for the same repository.\
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
    The cloudwatch alert can be triggered by running the following command:
    ```
    watch -n 1 'aws sqs send-message --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/63-image-generation-queue-prod" --message-body "A man eating hotdogs" --region eu-west-1'
    ```
    The alarm can be found on the cloudwatch alarm page under **63-queue-message-age-prod**

- Task 5
    1. Automation and Continuous Delivery
        - Serverless:
            Serverless technology integrates seamlessly with CI/CD workflows, 
            as it allows for independent deployment of each server function. However, 
            this can lead to a high number of server functions, each requiring its own automation, making monitoring and management more complex.
        
        - Microservices:
            Microservices often necessitate more complex CI/CD pipelines, 
            typically involving the creation and deployment of a Docker image.
            While the automation process might be more involved, there are generally fewer microservices than serverless functions.
    
    2. Observability
        - Serverless:
            Monitoring tools are vendor dependent, This limits customization to whatever the vendor allows.
            In this exam we have used AWS cloudwatch. Due to the ability to monitor individual functions one might get
            a bit more granularity in the metrics that are collected.

        - Microservices:
            It is more common to implement custom or semi-custom logging solutions.
            A commonly used data visualization platform is Grafana. This allows
            for lots more customization in data visualization.

    3. Scalability and cost control
        - Serverless:
            Assuming it is utilizing the services provided correctly it will scale automatically within
            the specified parameters automatically. With the more agile scaling you end up paying for only for the processing used.

        - Microservices:
            Assuming the service is built properly using microservices the scalability should be more or less the same during higher loads.
            Due to the microservices being allocated to their own virtual machines a bit of granularity is lost in the scaling. This
            lack of scaling granularity is where most of the cost difference between serverless and microservices lies.

    4. Ownership and responsibility
        - Serverless:
            Almost all the infrastructure management is offloaded to the service provider, 
            This reduces the burden on the DevOps team. However a great deal of control over the service is also lost.
            Using serverless providers that are not Openstack compliant makes the service provider reliant, 
            thus making it impossible to migrate providers in a short timeframe.
        
        - Microservices:
            This puts the responsibility of managing the whole stack on the DevOps team. It also
            makes it easier to avoid vendor lock inn by implementing standards like the Openstack standard.
            This gives the DevOps team a lot more control over the application. With this control a lot more
            responsibility follows.

    Personally I would implement a hybrid architecture. Using microservices for core services and serverless functions
    for more generic functionality. This would provide control where needed and offload work from the DevOps team.

