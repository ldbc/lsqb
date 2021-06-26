import psycopg2
import time
import sys
import signal
from contextlib import contextmanager

@contextmanager
def timeout(t):
    signal.signal(signal.SIGALRM, raise_timeout)
    signal.alarm(t)

    try:
        yield
    except TimeoutError:
        raise
    finally:
        signal.signal(signal.SIGALRM, signal.SIG_IGN)

def raise_timeout(signum, frame):
    raise TimeoutError

def run_query(con, variant, sf, query_id, query_spec, system, results_file):
    start = time.time()
    cur = con.cursor()
    try:
        with timeout(300):
            cur.execute(query_spec)
    except TimeoutError:
        return
    result = cur.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"{system}\t{variant}\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf [system] [variant]")
    print("where sf is the scale factor and system/variant are optional (default: system='PostgreSQL', variant='')")
    exit(1)
else:
    sf = sys.argv[1]

if len(sys.argv) > 2:
    system = sys.argv[2]
else:
    system = "PostgreSQL"

if len(sys.argv) > 3:
    variant = sys.argv[3]
else:
    variant = ""

con = psycopg2.connect(host="localhost", user="postgres", password="mysecretpassword", port=5432)

with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        with open(f"sql/q{i}.sql", "r") as query_file:
            run_query(con, variant, sf, i, query_file.read(), system, results_file)
