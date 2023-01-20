import sys
import os 
import pandas as pd

# for debugging print all the args in the system environment
# print(sys.argv)

# day = sys.argv[1]
day = os.getenv("DAY")
# some fancy stuff with pandas

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

python upload-data.py \
    --user = root \
    --password = root \
    --host = localhost \
    --port = 5432 \
    --db_name = ny_taxi \
    --tbl_name = yellow_taxi_data \
    --url = ${URL}

print(f'job finished successfully for day = {day}')