import json
import os
import time
from urllib.parse import unquote_plus

import boto3


def get_dynamodb_resource():
    region = os.environ.get("AWS_REGION") or os.environ.get(
        "AWS_DEFAULT_REGION") or "us-east-1"
    endpoint = os.environ.get("AWS_ENDPOINT_URL_DYNAMODB")
    kwargs = {"region_name": region}
    if endpoint:
        kwargs["endpoint_url"] = endpoint
    return boto3.resource("dynamodb", **kwargs)


def _first_photo(event):
    records = event.get("Records", [])
    if records:
        record = records[0]
        bucket = record.get("s3", {}).get("bucket", {}).get("name", "manual")
        key = record.get("s3", {}).get("object", {}).get("key", "unknown")
        filename = unquote_plus(key)
        return {
            "photo_id": f"{bucket}/{filename}",
            "filename": filename,
            "source_bucket": bucket,
        }

    filename = event.get("filename", "manual-photo.txt")
    return {
        "photo_id": event.get("photo_id", filename),
        "filename": filename,
        "source_bucket": event.get("source_bucket", "manual"),
    }


def handler(event, context):
    dynamodb = get_dynamodb_resource()
    table = dynamodb.Table(os.environ["METADATA_TABLE_NAME"])
    photo = _first_photo(event)

    item = {
        "photo_id": photo["photo_id"],
        "filename": photo["filename"],
        "source_bucket": photo["source_bucket"],
        "status": "received",
        "uploaded_at": str(int(time.time())),
    }

    table.put_item(Item=item)

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "photo metadata recorded",
                "item": item,
            }
        ),
    }
