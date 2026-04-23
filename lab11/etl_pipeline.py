import requests 
import pandas as pd
import sqlite3
import logging
from logging.handlers import RotatingFileHandler
from datetime import datetime, UTC
from tenacity import retry, stop_after_attempt, wait_exponential 

# LOGGING
logger = logging.getLogger("etl")
logger.setLevel(logging.INFO)

handler = RotatingFileHandler("etl_pipeline.log", maxBytes=1000000, backupCount=3)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)

# EXTRACT
@retry(stop=stop_after_attempt(3), wait=wait_exponential(min=2, max=10))
def fetch_users():
    url = "https://randomuser.me/api/?results=20"
    response = requests.get(url, timeout=10)
    response.raise_for_status()
    return response.json()

def extract(existing_emails=None):
    logger.info("Starting extract")

    data = fetch_users()
    df = pd.json_normalize(data['results'])

    if existing_emails is not None:
        df = df[~df['email'].isin(existing_emails)]

    logger.info(f"Extracted rows: {len(df)}")
    return df

# TRANSFORM
def transform(df):
    logger.info("Starting transform")

    if df.empty:
        return df

    df['first_name'] = df['name.first']
    df['last_name'] = df['name.last']
    df['age'] = df['dob.age']
    df['dob_date'] = pd.to_datetime(df['dob.date']).dt.date

    df['age_group'] = pd.cut(
        df['age'],
        bins=[0, 17, 30, 60, 200],
        labels=['Child', 'Young Adult', 'Adult', 'Senior']
    )

    df['email_domain'] = df['email'].str.split('@').str[1]
    df['loaded_at'] = datetime.now(UTC).isoformat()

        # WARNING checks BEFORE cleaning
    if df['email'].isna().any():
        logger.warning("Missing emails found")

    if df.duplicated(subset=['email']).any():
        logger.warning("Duplicate emails found")

    # CLEANING
    df = df.dropna(subset=['email'])
    df = df.drop_duplicates(subset=['email'], keep='first')

    df = df[
        ['email','gender','first_name','last_name','nat','age','age_group','email_domain','dob_date','loaded_at']
    ]

    logger.info(f"Transformed rows: {len(df)}")
    return df

# CONTROL
def get_existing_emails(conn):
    try:
        rows = conn.execute("SELECT email FROM users").fetchall()
        return {r[0] for r in rows}
    except:
        return set()

def update_last_email(conn, df):
    if not df.empty:
        max_email = df['email'].max()
        conn.execute("""
        CREATE TABLE IF NOT EXISTS etl_control (
            key TEXT PRIMARY KEY,
            value TEXT
        )
        """)
        conn.execute("""
        INSERT OR REPLACE INTO etl_control (key, value)
        VALUES ('last_email', ?)
        """, (max_email,))

# LOAD
def load(df):
    logger.info("Starting load")

    conn = sqlite3.connect("users.db")

    df = df.rename(columns={'nat': 'nationality'})

    conn.execute("""
    CREATE TABLE IF NOT EXISTS users (
        email TEXT PRIMARY KEY,
        gender TEXT,
        first_name TEXT,
        last_name TEXT,
        nationality TEXT,
        age INTEGER,
        age_group TEXT,
        email_domain TEXT,
        dob_date TEXT,
        loaded_at TEXT
    )
    """)

    rows = df.values.tolist()

    conn.executemany("""
    INSERT OR IGNORE INTO users
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, rows)

    inserted = conn.total_changes

    update_last_email(conn, df)

    conn.commit()

    inserted = conn.total_changes

    conn.close()

    logger.info(f"Loaded rows: {inserted}")
    return inserted

# MAIN
def run_etl():
    try:
        logger.info("ETL START")

        conn = sqlite3.connect("users.db")
        existing = get_existing_emails(conn)
        conn.close()

        df = extract(existing)
        df = transform(df)
        rows = load(df)

        logger.info("ETL END")

        return rows

    except Exception as e:
        with open("alert.log", "a") as f:
            f.write(str(e) + "\n")
        logger.error("ERROR", exc_info=True)
        raise


# if __name__ == "__main__":
#     df = extract()
#     print(df[['email', 'gender']].head())
#     print("Rows:", len(df))


# if __name__ == "__main__":
#     df = extract()
#     df = transform(df)
#     print(df[['first_name', 'age_group', 'email_domain']].head())


# if __name__ == "__main__":
#     df = extract()
#     df = transform(df)
#     rows = load(df)
#     print("Loaded:", rows)


# conn = sqlite3.connect("users.db")
# emails = get_existing_emails(conn)
# print(len(emails))



# df = extract()
# df = transform(df)

# x = 1 / 0   

# rows = load(df)





