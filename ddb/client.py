import duckdb
import time
import sys

def run_query(con, sf, query_id, query_spec, numThreads):
    start = time.time()
    con.execute(f"PRAGMA threads={numThreads};\n" + query_spec)
    result = con.fetchall()
    end = time.time()
    duration = end - start
    print(f"DuckDB\t{numThreads}\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}")
    return (duration, result)

if len(sys.argv) < 2:
  print("Usage: client.py sfX")
  print("where X is the scale factor")
  exit(1)
else:
  sf = sys.argv[1]

con = duckdb.connect(database='ddb/scratch/ldbc.duckdb', read_only=True)

for i in range(1, 7):
  with open(f"sql/q{i}.sql", "r") as f:
    run_query(con, sf, i, f.read(), 4)
