import duckdb
import os

con = duckdb.connect(database="ddb/scratch/ldbc.duckdb")

sf = os.environ.get("SF")
with open("rdm/conv.sql", "r") as f:
    conversion_script = f.read().replace("SCALE_FACTOR", sf)
    con.execute(conversion_script)

con.close()
