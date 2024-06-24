from sqlalchemy import create_engine, text
import pymysql 
import pandas as pd

#pd.set_option('display.max_rows', None)
#pd.set_option('display.max_columns', None)

# Database configuration
DB_NAME = 'u896388463_a3uoA'
DB_USER = 'u896388463_7vUOh'
DB_PASSWORD = 'u7hfSPgkON'
DB_HOST = 'srv939.hstgr.io'
DB_CHARSET = 'utf8'

# Connection string
connection_string = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}?charset={DB_CHARSET}"

# Create an engine
engine = create_engine(connection_string, future=True)

# Test Connection
def test_connection():
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT NOW()"))
            current_time = result.scalar_one()
            print(f"Connection successful! Current database time is: {current_time}")
    except Exception as e:
        print(f"Connection failed: {e}")
