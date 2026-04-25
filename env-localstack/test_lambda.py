import json
import os
import sys

# Add the lambda directory to path
sys.path.append('../module-photo-processor/lambda')

# Set LocalStack environment variables
os.environ['AWS_ACCESS_KEY_ID'] = 'test'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'test'
os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'
os.environ['AWS_ENDPOINT_URL_DYNAMODB'] = 'http://localhost:4566'
os.environ['AWS_ENDPOINT_URL_S3'] = 'http://localhost:4566'
os.environ['AWS_ENDPOINT_URL_LAMBDA'] = 'http://localhost:4566'

# Set Lambda environment variables (from Terraform)
os.environ['METADATA_TABLE_NAME'] = 'photo_metadata'
os.environ['PROCESSED_BUCKET_NAME'] = 'processed-photos'

# Import the handler
from photo_processor import handler

# Sample event (simulate S3 event or manual)
sample_event = {
    "photo_id": "test-photo-123",
    "filename": "sample-photo.txt",
    "source_bucket": "incoming-photos"
}

# Mock context (minimal)
class MockContext:
    def __init__(self):
        self.aws_request_id = "test-request-id"
        self.function_name = "photo-processor"

context = MockContext()

# Run the handler
if __name__ == "__main__":
    print("Testing Lambda handler locally...")
    try:
        result = handler(sample_event, context)
        print("Handler result:", json.dumps(result, indent=2))
    except Exception as e:
        print("Error:", str(e))
        import traceback
        traceback.print_exc()