from sqlalchemy import create_engine, insert, update, delete, text
from sqlalchemy import inspect
from dotenv import load_dotenv
import urllib
import os

load_dotenv()

AZURE_SERVER = os.environ.get('AZURE_SERVER')
AZURE_DATABASE = os.environ.get('AZURE_DATABASE')
AZURE_USERNAME = os.environ.get('AZURE_USERNAME')
AZURE_PASSWORD = os.environ.get('AZURE_PASSWORD')
AZURE_DRIVER = os.environ.get('AZURE_DRIVER')

azureParams = urllib.parse.quote_plus(
    'Driver={};'.format(AZURE_DRIVER)+
    'Server=tcp:{},1433;'.format(AZURE_SERVER)+
    'Database={};'.format(AZURE_DATABASE)  +
    'Uid={};'.format(AZURE_USERNAME) +
    'Pwd={};'.format(AZURE_PASSWORD) +
    'Encrypt=yes;' +
    'TrustServerCertificate=no;' +
    'Connection Timeout=30;')


conn = 'mssql+pyodbc:///?odbc_connect=' + azureParams
engine = create_engine(conn) 


def checkSqlConnection():
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1"))
        if result:
            print('works')
            return True
            
        else:
            print('doesnt work')
            return False
            

def uploadDataframeToAzure(df, dbName):
    df.to_sql(dbName, engine, if_exists='replace', index=False)
