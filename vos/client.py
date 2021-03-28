import time
import sys
import traceback
from SPARQLWrapper import SPARQLWrapper, JSON

endpoint = 'http://localhost:8890/sparql'
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
    results = query_fun(sparql, query_spec)
    end = time.time()
    duration = end - start
    json_results = results.convert()
    result = 0

    if len(json_results["results"]) > 0 and  'count' in  json_results["results"]["bindings"][0]:
        result = int(json_results["results"]["bindings"][0]["count"]["value"])
    results_file.write(f"Virtuoso\t\t{sf}\t{query_id}\t{duration:.4f}\t{result}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf")
    print("where sf is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]


with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        print(f"Q{i}")
        with open(f"sparql/q{i}.sparql", "r") as query_file:
            run_query(sparql, sf, i, query_file.read(), results_file)


