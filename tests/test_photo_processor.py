import pytest
from moto import mock_aws
import boto3
import os
import sys

# Add the lambda directory to path
sys.path.insert(0, 'module-photo-processor/lambda')

from photo_processor import handler


@pytest.fixture
def dynamodb_table():
    """Fixture to create a mock DynamoDB table."""
    with mock_aws():
        dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        table = dynamodb.create_table(
            TableName='photo_metadata',
            KeySchema=[
                {'AttributeName': 'photo_id', 'KeyType': 'HASH'}
            ],
            AttributeDefinitions=[
                {'AttributeName': 'photo_id', 'AttributeType': 'S'}
            ],
            BillingMode='PAY_PER_REQUEST'
        )
        yield table


@pytest.fixture
def mock_env():
    """Fixture to set environment variables."""
    os.environ['METADATA_TABLE_NAME'] = 'photo_metadata'
    os.environ['PROCESSED_BUCKET_NAME'] = 'processed-photos'
    yield
    # Clean up
    del os.environ['METADATA_TABLE_NAME']
    del os.environ['PROCESSED_BUCKET_NAME']


class MockContext:
    """Mock Lambda context."""
    def __init__(self):
        self.aws_request_id = "test-request-id"
        self.function_name = "photo-processor"


def test_handler_with_manual_event(dynamodb_table, mock_env):
    """Test handler with a manual event (no S3 records)."""
    event = {
        "photo_id": "manual-test-123",
        "filename": "test-photo.jpg",
        "source_bucket": "manual"
    }
    context = MockContext()

    result = handler(event, context)

    assert result['statusCode'] == 200
    assert 'photo metadata recorded' in result['body']

    # Check DynamoDB
    response = dynamodb_table.scan()
    items = response['Items']
    assert len(items) == 1
    item = items[0]
    assert item['photo_id'] == 'manual-test-123'
    assert item['filename'] == 'test-photo.jpg'
    assert item['source_bucket'] == 'manual'
    assert item['status'] == 'received'
    assert 'uploaded_at' in item


def test_handler_with_s3_event(dynamodb_table, mock_env):
    """Test handler with an S3 event."""
    event = {
        "Records": [
            {
                "s3": {
                    "bucket": {"name": "incoming-photos"},
                    "object": {"key": "uploaded-photo.png"}
                }
            }
        ]
    }
    context = MockContext()

    result = handler(event, context)

    assert result['statusCode'] == 200

    # Check DynamoDB
    response = dynamodb_table.scan()
    items = response['Items']
    assert len(items) == 1
    item = items[0]
    assert item['photo_id'] == 'incoming-photos/uploaded-photo.png'
    assert item['filename'] == 'uploaded-photo.png'
    assert item['source_bucket'] == 'incoming-photos'
    assert item['status'] == 'received'


def test_handler_with_empty_event(dynamodb_table, mock_env):
    """Test handler with minimal event."""
    event = {}
    context = MockContext()

    result = handler(event, context)

    assert result['statusCode'] == 200

    # Should use defaults
    response = dynamodb_table.scan()
    items = response['Items']
    assert len(items) == 1
    item = items[0]
    assert item['photo_id'] == 'manual-photo.txt'
    assert item['filename'] == 'manual-photo.txt'
    assert item['source_bucket'] == 'manual'