from neo4j import GraphDatabase, unit_of_work
import time

@unit_of_work(timeout=300)
def query_fun(tx, query):
    result = tx.run(query)
    return result.single()

def run_query(session, query_id, query_spec):
    start = time.time()
    result = session.read_transaction(query_fun, query_spec)
    end = time.time()
    duration = end - start
    print(f"Neo4j\t\t{query_id}\t{duration:.4f}\t{result[0]}")
    return (duration, result)

driver = GraphDatabase.driver("bolt://localhost:7687")
session = driver.session()

for i in range(1, 7):
    with open(f"cypher/q{i}.cypher", "r") as f:
        run_query(session, i, f.read())  

session.close()
driver.close()
