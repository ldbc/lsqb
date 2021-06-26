import mysql.connector
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

def run_query(con, sf, query_id, query_spec, system, results_file):
    start = time.time()
    try:
        with timeout(1):
            cur = con.cursor()
    except TimeoutError:
        return
    cur.execute(query_spec)
    result = cur.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"{system}\t\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf [system]")
    print("where sf is the scale factor and system if optional (default: MySQL)")
    exit(1)
else:
    sf = sys.argv[1]

if len(sys.argv) == 2:
    system = "MySQL"
else:
    system = sys.argv[2]

con = mysql.connector.connect(host="localhost", user="root", password="", port=3306, database="lsqb")

with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        with open(f"sql/q{i}.sql", "r") as query_file:
            run_query(con, sf, i, query_file.read(), system, results_file)
