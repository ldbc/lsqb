import duckdb
import time

def run_query(con, query_id, query_spec):
    start = time.time()
    con.execute(query_spec)
    result = con.fetchall()
    end = time.time()
    duration = end - start
    print("Q{}: {:.4f} seconds, {} tuples".format(query_id, duration, result[0][0]))
    return (duration, result)

con = duckdb.connect(database='ddb/scratch/ldbc.duckdb', read_only=True)

for i in range(1, 7):
  with open(f"sql/q{i}.sql", "r") as f:
    run_query(con, i, "PRAGMA threads=4;" + f.read())
