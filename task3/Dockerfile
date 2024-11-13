FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY java_sqs_client/pom.xml .
RUN mvn dependency:go-offline

COPY java_sqs_client/src/ ./src/

RUN mvn package

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV SQS_QUEUE_URL=""

COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
