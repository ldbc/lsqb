from neo4j import GraphDatabase

driver = GraphDatabase.driver("bolt://localhost:17687")

def triangle_tx(tx):
    result = tx.run("MATCH (p1:Person)-[:KNOWS]-(p2:Person)-[:KNOWS]-(p3:Person)-[:KNOWS]-(p1:Person) RETURN count(*) AS triangleCount")
    return result.single()

with driver.session() as session:
    result = session.read_transaction(triangle_tx)
    print(result)
driver.close()
