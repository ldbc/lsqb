import time
import sys
import redis
from redisgraph import Node, Edge, Graph, Path

def run_query(session, sf, query_id, query_spec, results_file):
    start = time.time()
    result = graph.query(query_spec)
    end = time.time()
    duration = end - start
    results_file.write(f"RedisGraph\t\t{sf}\t{query_id}\t{duration:.4f}\t{result.result_set[0][0]}\n")
    return (duration, result)

if len(sys.argv) < 2:
  print("Usage: client.py sfX")
  print("where X is the scale factor")
  exit(1)
else:
  sf = sys.argv[1]

redis = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', redis)

with open(f"results/results.csv", "a+") as results_file:
  for i in range(1, 7):
      with open(f"red/q{i}.cypher", "r") as query_file:
          run_query(graph, sf, i, query_file.read(), results_file)
