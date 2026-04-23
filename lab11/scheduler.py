import time
from datetime import datetime
from etl_pipeline import run_etl

for i in range(6):
    print(f"Running ETL at {datetime.now()}")
    run_etl()
    time.sleep(5)
