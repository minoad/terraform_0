# Documentation

This directory contains documentation for the photo processing application.

## Diagrams

- **[Architecture](architecture.md)** - High-level overview of AWS services and connections
- **[Event Flow](event-flow.md)** - Step-by-step sequence of events from upload to processing
- **[Complete Architecture](complete-architecture.md)** - Full system including Terraform structure and CI/CD
- **[Data Flow](data-flow.md)** - How data transforms through the processing pipeline

## Application Overview

This is a serverless photo processing application built with Terraform and AWS services (simulated via LocalStack). It demonstrates event-driven architecture with the following components:

- **S3**: Storage for incoming and processed photos
- **Lambda**: Serverless function for photo processing
- **DynamoDB**: Metadata storage
- **SNS/SQS**: Messaging for decoupling and notifications

## Learning Levels

See the main [README](../README.md) for the learning progression and implementation levels.