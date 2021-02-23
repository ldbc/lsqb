import duckdb
import time
import sys

def run_query(con, sf, query_id, query_spec, numThreads, results_file):
    start = time.time()
    con.execute(f"PRAGMA threads={numThreads};\n" + query_spec)
    result = con.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"DuckDB\t{numThreads}\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    return (duration, result)

if len(sys.argv) < 2:
  print("Usage: client.py sfX [threads]")
  print("where X is the scale factor")
  exit(1)
else:
  sf = sys.argv[1]

if len(sys.argv) > 2:
  numThreads = int(sys.argv[2])
else:
  numThreads = 1

con = duckdb.connect(database='ddb/scratch/ldbc.duckdb', read_only=True)

with open(f"results/results.csv", "a+") as results_file:
  for i in range(1, 7):
    with open(f"sql/q{i}.sql", "r") as query_file:
      run_query(con, sf, i, query_file.read(), numThreads, results_file)
