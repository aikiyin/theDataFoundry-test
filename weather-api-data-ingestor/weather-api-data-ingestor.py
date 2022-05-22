import boto3
import urllib.request
import json
import gzip
import time
import os
import logging
import datetime
from datetime import datetime as dt

logger = logging.getLogger()
logger.setLevel(logging.INFO)

logger.info("Loading function")

job_config = {
    "ingest_s3_bucket": "weather-api-data-landing",
    "ingest_s3_folder": "weather-api-data-hourly",
    "output_file_name": "weather_data_{}.json",
}


def extract_weather_api_data(output_file_name):
    try:
        weather_data = urllib.request.urlopen(
            "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en"
        ).read()
        with open(
            "/tmp/"
            + output_file_name.format(json.loads(weather_data)["iconUpdateTime"]),
            "w",
        ) as file:
            json.dump(json.loads(weather_data), file)
        return output_file_name.format(json.loads(weather_data)["iconUpdateTime"])
    except Exception as e:
        logger.error(
            f"Failed to retrieve & save weather data from endpoint into json file: {e}"
        )
        raise ValueError


def upload_json_file_to_s3(
    file_to_upload, destination_s3_bucket, destination_s3_folder, destination_file_path
):
    s3_client = boto3.client("s3")
    partition_by_year = dt.utcnow().year
    partition_by_month = dt.utcnow().month
    partition_by_day = dt.utcnow().day
    try:
        s3_client.upload_file(
            file_to_upload,
            destination_s3_bucket,
            f"{destination_s3_folder}/partition_year={partition_by_year}/partition_month={partition_by_month}/partition_day={partition_by_day}/{destination_file_path}",
        )
    except Exception as e:
        logger.error(f"Failed to upload file {file_to_upload} to S3 bucket: {e}")
        raise ValueError


def main(event, context):
    output_file_name = job_config["output_file_name"]
    file_extracted = extract_weather_api_data(output_file_name)
    upload_json_file_to_s3(
        "/tmp/" + file_extracted,
        job_config["ingest_s3_bucket"],
        job_config["ingest_s3_folder"],
        file_extracted,
    )
