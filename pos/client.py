import psycopg2
import time

def run_query(con, query_id, query_spec):
    start = time.time()
    cur = con.cursor()
    cur.execute(query_spec)
    result = cur.fetchall()
    end = time.time()
    duration = end - start
    print("Q{}: {:.4f} seconds, {} tuples".format(query_id, duration, result[0][0]))
    return (duration, result)

con = psycopg2.connect(host="localhost", user="postgres", password="mysecretpassword", port="5432")

for i in range(1, 7):
  with open(f"sql/q{i}.sql", "r") as f:
    run_query(con, i, f.read())
