import duckdb
import time
import sys
import signal
from contextlib import contextmanager
print(duckdb.__version__)

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

def run_query(con, sf, query_id, query_spec, numThreads, results_file):
    print(query_spec)
    start = time.time()
    try:
        with timeout(300):
            con.execute(f"PRAGMA threads={numThreads};\n" + query_spec)
    except TimeoutError:
        return
    result = con.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"DuckPGQ-{duckdb.__version__}\t{numThreads} threads\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

sf = None
if len(sys.argv) < 2:
    print("Usage: client.py sf [threads]")
    print("where sf is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]

if len(sys.argv) > 2:
    numThreads = int(sys.argv[2])
else:
    numThreads = 4

if sf is None:
    quit(1)

con = duckdb.connect(database=f'scratch/lsqb-{sf}.duckdb')

con.install_extension("duckpgq", repository="community", force_install=True)
con.load_extension("duckpgq")

with open(f"../results/results.csv", "a+") as results_file:
    for i in range(1,10):
        print(i)
        with open(f"../pgq/q{i}.sql", "r") as query_file:
            run_query(con, sf, i, query_file.read(), numThreads, results_file)

con.close()
