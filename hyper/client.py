import subprocess
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
        with timeout(300):
          out = subprocess.run(f'echo "{query_spec}" {con}', shell=True, capture_output=True)
    except TimeoutError:
        return
    result = int(out.stdout.decode('utf-8').split('\n')[2].strip())
    print(result)
    end = time.time()
    duration = end - start
    results_file.write(f"{system}\t\t{sf}\t{query_id}\t{duration:.4f}\t{result}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf [system]")
    print("where sf is the scale factor and system if optional (default: HyPer)")
    exit(1)
else:
   sf = sys.argv[1]

system = "HyPer"

con = "| docker exec -i ${HYPER_CONTAINER_NAME} psql -U lsqbuser -p 7484 -h localhost ${HYPER_DATABASE_NAME}"

with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        with open(f"sql/q{i}.sql", "r") as query_file:
            run_query(con, sf, i, query_file.read(), system, results_file)

