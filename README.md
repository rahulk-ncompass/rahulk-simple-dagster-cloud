# Simple Dagster Cloud

A minimal Dagster orchestration setup deployed on AWS with Docker containerization and CodeDeploy automation. This project demonstrates how to run Dagster workloads in a containerized environment on cloud infrastructure.

## What is this?

This repository contains a simple Dagster job orchestration setup that includes:

- **Dagster Assets**: Two basic computational assets (addition and multiplication)
- **Docker Containers**: Multi-container setup for the Dagster code server, webserver, and daemon
- **AWS Deployment**: Automated build and deployment using CodeBuild and CodeDeploy
- **gRPC Code Server**: Containerized code execution server running on port 4000
- **Web UI**: Dagster webserver accessible on port 3000

## Stack

- **Language:** Python 3.12
- **Framework / Runtime:** Dagster (orchestration platform)
- **Key Libraries:** 
  - `dagster` - Core orchestration engine
  - `dagster-webserver` - Web UI for job monitoring and execution
- **Deployment:** Docker + Docker Compose
- **CI/CD:** AWS CodeBuild + AWS CodeDeploy
- **Storage:** SQLite (local storage in `dagster_home`)

## How it's organized

simple_dagster/ Dagster job definitions and assets assets.py Computational assets (addition, multiplication) definitions.py Dagster Definitions entry point

scripts/ Deployment scripts start_container.sh Docker Compose startup with ECR login stop_container.sh Container shutdown

Dockerfile Multi-stage Python image, runs gRPC code server docker-compose.yaml Three-service setup: code, webserver, daemon dagster.yaml Dagster configuration (telemetry, storage) workspace.yaml Workspace pointing to gRPC code server buildspec.yaml AWS CodeBuild build specification appspec.yml AWS CodeDeploy deployment specification pyproject.toml Python project metadata requirements.txt Python dependencies

Code

**How it fits together:**

The architecture uses three Docker containers orchestrated by Docker Compose:

1. **dagster-code** (gRPC server): Runs the actual Dagster code and exposes a gRPC interface on port 4000. The code server loads `simple_dagster.definitions` containing the two asset definitions.

2. **dagster-webserver**: Connects to the code server via the workspace configuration (`workspace.yaml`) and provides a web UI on port 3000 for viewing and triggering runs.

3. **dagster-daemon**: Runs the Dagster daemon process for scheduling and event handling.

All three services share a single `dagster_home` volume for persistent state (SQLite database). The deployment pipeline uses AWS CodeBuild to build the Docker image and push it to Amazon ECR, then CodeDeploy handles the container orchestration on the target EC2 instance.

## Flow:
Codepipeline(source: github) -> Codedeploy(create a image and push to ECR, appspec.yml as artifact) -> codedeploy(uses the artifact and run the container)
