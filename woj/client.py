import time
import sys
import traceback
from SPARQLWrapper import SPARQLWrapper, JSON

endpoint = 'http://localhost:8890/ldbc/sparql'
sparql = SPARQLWrapper(endpoint)
sparql.setTimeout(300)
sparql.setReturnFormat(JSON)


# @unit_of_work(timeout=300)
def query_fun(sparql, query):
    sparql.setQuery(query)
    results = sparql.query()
    return results

def run_query(sparql, sf, query_id, query_spec, results_file):
    start = time.time()
    try:
      results = query_fun(sparql, query_spec)
      end = time.time()
      json_results = results.convert()
    except:
      end = time.time()
      json_results={'results':[]}

    duration = end - start

    result = -1

    if len(json_results["results"]) > 0 and  'count' in  json_results["results"]["bindings"][0]:
        result = int(json_results["results"]["bindings"][0]["count"]["value"])
    results_file.write(f"Jena-Leapfrog\t\t{sf}\t{query_id}\t{duration:.4f}\t{result}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sfX")
    print("where X is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]


with open(f"results/results.csv", "a+") as results_file:
    num_failed = 0
    for i in range(0, 7):
        with open(f"sparql/q{i}.sparql", "r") as query_file:
            duration, result = run_query(sparql, sf, i, query_file.read(), results_file)
            if result <0:
                num_failed+=1
    if num_failed > 0:
        print("Failed {}".format(num_failed))

