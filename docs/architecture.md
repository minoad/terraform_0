# Photo Processing Application Diagrams

This directory contains architectural diagrams for the photo processing application.

## High-Level Architecture

```mermaid
graph TD
    A[S3 Bucket: incoming-photos] --> B[S3 Event Notification]
    B --> C[Lambda Function: photo-processor]
    C --> D[DynamoDB Table: photo_metadata]
    C --> E[SNS Topic: photo-processed]
    E --> F[SQS Queue: photo-notifications]

    subgraph "LocalStack AWS Services"
        A
        D
        E
        F
    end

    subgraph "Lambda Processing"
        C
    end

    style A fill:#e1f5fe
    style D fill:#f3e5f5
    style E fill:#e8f5e8
    style F fill:#fff3e0
```

Shows the main AWS services and their connections in the event-driven pipeline.