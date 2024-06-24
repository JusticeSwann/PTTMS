import wpDatabaseConfig as wp
import azureDataWarehouseConfig as az
import pandas as pd

#wp.test_connection()

def getDataFromWpFluentFroms():
    #allTablesQuery = "SELECT table_name FROM information_schema.tables"
    query = "SELECT * FROM wp_fluentform_entry_details"

    with wp.engine.connect() as connection:
        result = connection.execute(wp.text(query))
        df = pd.DataFrame(result.fetchall(), columns=result.keys())
        return df
    
