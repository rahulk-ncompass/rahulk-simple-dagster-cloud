#!/bin/bash

set -e

echo "Starting Dagster deployment..."

cd /home/ubuntu/rahulk-dagster

echo "Fetching MySQL credentials from AWS Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id dagster/mysql \
  --region ap-south-1 \
  --query SecretString \
  --output text)

export DAGSTER_MYSQL_HOST=$(echo "$SECRET_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin)["DAGSTER_MYSQL_HOST"])')
export DAGSTER_MYSQL_USERNAME=$(echo "$SECRET_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin)["DAGSTER_MYSQL_USERNAME"])')
export DAGSTER_MYSQL_PASSWORD=$(echo "$SECRET_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin)["DAGSTER_MYSQL_PASSWORD"])')
export DAGSTER_MYSQL_DB=$(echo "$SECRET_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin)["DAGSTER_MYSQL_DB"])')

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region ap-south-1 | \
docker login --username AWS \
--password-stdin 368355641188.dkr.ecr.ap-south-1.amazonaws.com

echo "Pulling latest Dagster image..."
docker pull 368355641188.dkr.ecr.ap-south-1.amazonaws.com/rahulk-dagster:latest

echo "Starting Dagster containers..."
docker compose up -d

echo "Dagster deployment completed successfully!"