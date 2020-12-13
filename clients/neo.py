from neo4j import GraphDatabase

driver = GraphDatabase.driver("bolt://localhost:17687")
with driver.session() as session:
    tx = session.read_transaction(match_person_nodes)
    result = tx.run("MATCH (p1:Person)-[:KNOWS]-(p2:Person)-[:KNOWS]-(p3:Person)-[:KNOWS]-(p1:Person) RETURN count(*) AS count")
    print(result)
driver.close()
