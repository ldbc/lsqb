from neo4j import GraphDatabase, unit_of_work
import time
import sys

@unit_of_work(timeout=3000)
def query_fun(tx, query):
    result = tx.run(query)
    return result.single()

def run_query(session, system_variant, sf, query_id, query_spec, results_file):
    start = time.time()
    # turn on the parallel runtime for the Enterprise edition
    if system_variant == "enterprise":
        query_spec = f"CYPHER runtime=parallel {query_spec}"
    result = session.read_transaction(query_fun, query_spec)
    end = time.time()
    duration = end - start
    results_file.write(f"Neo4j\t{system_variant}\t{sf}\t{query_id}\t{duration:.4f}\t{result[0]}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf <system variant>")
    print("Where sf is the scale factor and the system variant is the edition used (e.g. community, enterprise)")
    exit(1)
else:
    sf = sys.argv[1]

if len(sys.argv) > 2:
    system_variant = sys.argv[2]
else:
    system_variant = "default"

driver = GraphDatabase.driver("bolt://localhost:7687")
session = driver.session()

with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        with open(f"cypher/q{i}.cypher", "r") as query_file:
            run_query(session, system_variant, sf, i, query_file.read(), results_file)

session.close()
driver.close()
