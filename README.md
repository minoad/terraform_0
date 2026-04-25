# Terraform LocalStack Photo Booth

A small, local-first Terraform project for learning cloud infrastructure without AWS cost anxiety.

The project idea is a tiny event-driven "photo booth" system:

1. A file is uploaded to an S3 bucket.
2. The upload triggers a Lambda function.
3. The Lambda records metadata in DynamoDB.
4. The Lambda writes a processed result to another S3 bucket.
5. Optional messaging sends a notification through SNS or SQS.

Everything runs against LocalStack, so you can explore Terraform plans, applies, destroys, refactors, and state changes without provisioning real AWS resources.

## Why This Project

Terraform is not quite like Python. You do not usually learn it by solving arbitrary puzzles. You learn it by building little systems, changing them, breaking them, and watching how Terraform reasons about the desired state.

This project is meant to give you a small world to experiment in.

You will practice:

- Terraform providers
- LocalStack endpoints
- S3 buckets
- Lambda functions
- IAM roles and policies
- DynamoDB tables
- S3 event notifications
- SNS or SQS messaging
- Variables
- Outputs
- Modules
- Terraform state
- Resource dependencies
- Safe iteration with `terraform plan`

## Project Shape

The repo is split into a reusable module and a local environment:

```text
.
├── docker-compose.yml
├── env-localstack/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── module-photo-processor/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── lambda/
│       └── photo_processor.py
└── sample-photo.txt
```

Run Terraform from `env-localstack`. That environment configures the AWS provider for LocalStack and calls `module-photo-processor`.

The module owns the AWS-shaped resources:

- S3 buckets
- DynamoDB table
- Lambda package and function
- Lambda IAM role and policy

That split keeps LocalStack-specific settings out of the reusable module, which makes it easier to add a real AWS environment later.

## Learning Path

### Level 1: Buckets

Create two S3 buckets:

- `incoming-photos`
- `processed-photos`

Practice:

- Configuring the AWS provider for LocalStack
- Creating resources
- Using outputs
- Running `terraform plan`
- Running `terraform apply`
- Inspecting resources with `awslocal`

Try:

```powershell
cd env-localstack
terraform init
terraform plan
terraform apply
awslocal s3 ls
```

This repo now starts here, with `env-localstack` calling `module-photo-processor` to create:

- `incoming-photos`
- `processed-photos`
- `photo_metadata`
- `photo-processor`

### Level 2: Database

Add a DynamoDB table named `photo_metadata`.

Suggested fields:

- `photo_id`
- `filename`
- `uploaded_at`
- `status`

Practice:

- Adding a new resource
- Choosing a partition key
- Reading Terraform diffs
- Understanding what changes force replacement

### Level 3: Lambda

Write a small Python Lambda function that receives an S3 event and records metadata in DynamoDB.

Practice:

- Packaging Lambda code
- Creating IAM roles
- Attaching IAM policies
- Passing environment variables to Lambda
- Connecting infrastructure to application code

### Level 4: S3 Events

Configure the incoming bucket to trigger the Lambda when a new object is created.

Practice:

- Event notifications
- Explicit dependencies
- Debugging event-driven systems locally
- Understanding where Terraform configuration ends and runtime behavior begins

### Level 5: Messaging

Add SNS or SQS.

Ideas:

- Publish a "photo processed" notification to SNS
- Push processing jobs into SQS
- Add a second Lambda that consumes messages

Practice:

- Decoupling services
- Wiring resources together with ARNs and URLs
- Adding outputs that make local testing easier

### Level 6: More Modules

The project now has one focused module, `module-photo-processor`. Later, you can split it further if the boundaries start to feel useful:

- `modules/storage`
- `modules/database`
- `modules/functions`
- `modules/messaging`

Practice:

- Module inputs
- Module outputs
- Resource naming conventions
- Keeping environment Terraform files readable

### Level 7: Break Things on Purpose

Once the system works, deliberately change it.

Try:

- Rename a bucket
- Change a DynamoDB key
- Move resources into modules
- Remove a resource
- Run `terraform state list`
- Run `terraform state show`
- Try `terraform import`

This is where Terraform starts becoming less mysterious.

## LocalStack

This project assumes LocalStack is running locally.

A minimal `docker-compose.yml` can expose LocalStack on port `4566` and enable the services you need:

- S3
- Lambda
- IAM
- DynamoDB
- SNS
- SQS

This repo pins `localstack/localstack:4.14.0`, the pre-2026 community image line, so the project stays local and does not require a LocalStack auth token.

Typical commands:

```powershell
docker compose up -d
docker compose logs -f localstack
docker compose down
```

## Useful Commands

Terraform:

```powershell
cd env-localstack
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
terraform state list
```

LocalStack AWS CLI:

```powershell
awslocal s3 ls
awslocal dynamodb list-tables
awslocal lambda list-functions
awslocal sns list-topics
awslocal sqs list-queues
```

Upload a test file:

```powershell
awslocal --region us-east-1 s3 cp ..\sample-photo.txt s3://incoming-photos/sample-photo.txt
```

Inspect processed output:

```powershell
awslocal s3 ls s3://processed-photos/
```

## Secret Scanning Hook

This repo includes a lightweight pre-commit hook at `.githooks/pre-commit` that scans staged files for common secrets before Git creates a commit.

Enable it once per clone:

```powershell
.\scripts\install-hooks.ps1
```

Or run the Git command directly:

```powershell
git config core.hooksPath .githooks
```

The hook checks for common tokens and credentials, including AWS keys, OpenAI keys, GitHub tokens, Slack tokens, Google API keys, private key blocks, and generic secret assignments.

## CI Checks

GitHub Actions runs Terraform checks on pull requests and pushes to `main`:

```text
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Once the workflow has run at least once on GitHub, it can be added as a required status check in the repository ruleset.

## Suggested Rules For Learning

- Run `terraform plan` before every apply.
- Read the plan instead of skipping past it.
- Change one thing at a time when learning a new concept.
- Keep outputs useful for manual testing.
- Break the project intentionally after it works.
- Use `terraform destroy` freely because everything is local.

## Stretch Ideas

- Add object tags to uploaded files.
- Store file size and content type in DynamoDB.
- Add a dead-letter queue.
- Add a second Lambda for thumbnail generation.
- Add a small CLI script that uploads fake photos.
- Use Terraform workspaces for `dev` and `experiment`.
- Add a `Makefile` or PowerShell task file for common commands.

## Goal

By the end, you should be comfortable reading Terraform plans, connecting resources together, splitting configuration into modules, and recovering when state or resource names get weird.

The point is not to memorize every AWS resource. The point is to build enough muscle memory that Terraform starts to feel like a tool you can explore with.
