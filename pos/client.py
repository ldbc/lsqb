import psycopg2
import time
import sys

def run_query(con, query_id, query_spec, system):
    start = time.time()
    cur = con.cursor()
    cur.execute(query_spec)
    result = cur.fetchall()
    end = time.time()
    duration = end - start
    print(f"{system}\t\t{query_id}\t{duration:.4f}\t{result[0][0]}")
    return (duration, result)

if len(sys.argv) == 1:
  system = "PostgreSQL"
else:
  system = sys.argv[1]

con = psycopg2.connect(host="localhost", user="postgres", password="mysecretpassword", port=5432)

for i in range(1, 7):
  with open(f"sql/q{i}.sql", "r") as f:
    run_query(con, i, f.read(), system)
