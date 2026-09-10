import json
import pymysql
import os
from datetime import datetime

RDS_HOST = os.environ['RDS_HOST']
RDS_USER = os.environ['RDS_USER']
RDS_PASS = os.environ['RDS_PASS']
RDS_DB = os.environ['RDS_DB']


def handler(event, context):
    record = event['Records'][0]
    key = record['s3']['object']['key']
    filename = key.split('/')[-1]

    conn = pymysql.connect(
        host=RDS_HOST,
        user=RDS_USER,
        password=RDS_PASS,
        db=RDS_DB,
        connect_timeout=5
    )

    try:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO file_metadata "
                "(filename, upload_time, status) "
                "VALUES (%s, %s, %s)",
                (filename, datetime.utcnow(), "PROCESSED")
            )
            conn.commit()
    finally:
        conn.close()

    return {
        "statusCode": 200,
        "body": json.dumps(
            f"Inserted metadata for {filename}"
        )
    }
