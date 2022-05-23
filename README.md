# weather api data ingestor lambda
This repo provides a Terraform based framework to create a lambda function in aws to ingest weather data from: https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en"

# base lambda module
The lambda base module provides a base for any new lambda functions to be created. It includes a python dependency installing step, which uses pipenv. 

To create a new lambda function, create a new folder containing a Pipfile, even though no extra libraries are required.

# provider.tf 
provider.tf specifies all providers resource required for this repo

# assumptions
1. The data in source api is refreshed at every hour, so the lambda function is triggerd by a hourly schedule
2. The data extracted is stored as json format in s3
3. The data landing in s3 is partitioned by year, month, day