# weather api data ingestor lambda
This repo provides a Terraform based framework to create a lambda function in aws to ingest weather data from: https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en

# lambda base module
The lambda base module provides a base for any new lambda functions to be created. It includes a python dependency installing step, which uses pipenv. 

To create a new lambda function, create a new folder containing a Pipfile, even though no extra libraries are required.

# provider.tf 
provider.tf specifies all providers resource required for this repo (terraform / AWS / archive)

# assumptions
1. The data in source api is refreshed on a hourly basis, so the lambda function is triggerd on a hourly schedule
2. The data extracted is stored as json format in s3 using json.loads / json.dump
3. The data landing in s3 is partitioned by year, month, day

# Data Source
https://data.weather.gov.hk/weatherAPI/doc/HKO_Open_Data_API_Documentation.pdf
https://data.gov.hk/en-data/dataset/hk-hko-rss-current-weather-report/resource/a8257822-c69a-4984-acda-a04895df4de4