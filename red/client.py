import time
import sys
import redis
from redisgraph import Node, Edge, Graph, Path
import redis.exceptions
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

def run_query(session, sf, query_id, query_spec, results_file):
    start = time.time()
    try:
        with timeout(300):
            result = graph.query(query_spec)
    except redis.exceptions.ConnectionError:
        return
    end = time.time()
    duration = end - start
    results_file.write(f"RedisGraph\t\t{sf}\t{query_id}\t{duration:.4f}\t{result.result_set[0][0]}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf")
    print("where sf is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]

r = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', r)

with open(f"results/results.csv", "a+") as results_file:
     for i in range(1, 10):
          with open(f"red/q{i}.cypher", "r") as query_file:
              run_query(graph, sf, i, query_file.read(), results_file)
