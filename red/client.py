import time
import sys
import redis
from redisgraph import Node, Edge, Graph, Path

def run_query(session, sf, query_id, query_spec):
    #print(query_spec)
    start = time.time()
    result = graph.query(query_spec)
    end = time.time()
    duration = end - start
    #result.pretty_print()
    print(f"RedisGraph\t\t{sf}\t{query_id}\t{duration:.4f}\t{result.result_set}")
    return (duration, result)

if len(sys.argv) < 2:
  print("Usage: client.py sfX")
  print("where X is the scale factor")
  exit(1)
else:
  sf = sys.argv[1]

redis = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', redis)

for i in range(1, 7):
    with open(f"red/q{i}.cypher", "r") as f:
        run_query(graph, sf, i, f.read())
