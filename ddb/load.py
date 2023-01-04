import duckdb
import os

con = duckdb.connect(database="ddb/scratch/ldbc.duckdb")

with open("sql/schema.sql", "r") as f:
    schema_init_query = f.read()
    con.execute(schema_init_query)

data_dir = os.environ.get("IMPORT_DATA_DIR_MERGED_FK")
with open("sql/snb-load.sql", "r") as f:
    load_query = f.read().replace("PATHVAR", data_dir)
    con.execute(load_query)

with open("sql/views.sql", "r") as f:
    view_init_query = f.read()
    con.execute(view_init_query)

con.close()
