import mgclient
import time
import sys
import signal
from contextlib import contextmanager
from traceback import print_exc

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

def run_query(con, sf, query_id, query_spec, results_file):
    start = time.time()
    cur = con.cursor()
    try:
        with timeout(300):
            cur.execute(query_spec)
    except TimeoutError:
        return
    except mgclient.DatabaseError:
        print_exc()
        print(f"Memgraph\t\t{sf}\t{query_id}\t-\t-")
        return
    result = cur.fetchall()
    end = time.time()
    duration = end - start
    #print(f"Memgraph\t\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}")
    results_file.write(f"Memgraph\t\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf")
    print("where sf is the scale factor")
    exit(1)
else:
   sf = sys.argv[1]

con = mgclient.connect(host='127.0.0.1', port=27687)

with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        with open(f"mem/q{i}.cypher", "r") as query_file:
            run_query(con, sf, i, query_file.read(), results_file)
