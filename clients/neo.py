from neo4j import GraphDatabase
import time

def query_fun(tx, query):
    result = tx.run(query)
    return result.single()

def run_query(session, query):
    start = time.time()
    result = session.read_transaction(query_fun, query)
    end = time.time()
    duration = end - start
    print("{:.4f} seconds, {} tuples".format(duration, result[0]))
    return (duration, result)

driver = GraphDatabase.driver("bolt://localhost:17687")

with driver.session() as session:
    # example triangle query
    #run_query(session, "MATCH (p1:Person)-[:KNOWS]-(p2:Person)-[:KNOWS]-(p3:Person)-[:KNOWS]-(p1:Person) RETURN count(*) AS triangleCount")
    run_query(session, """
        MATCH (:Country)<-[:IS_PART_OF]-(:City)<-[:IS_LOCATED_IN]-(:Person)<-[:HAS_MODERATOR]-(:Forum)-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF*0..]-(:Message)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(:TagClass)
        RETURN count(*) AS count
        """)
    run_query(session, """
        MATCH (:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]-(:Person)
        OPTIONAL MATCH (m)<-[:LIKES]-(lp:Person)
        OPTIONAL MATCH (m)<-[:REPLY_OF]-(rc:Comment)
        RETURN count(*) AS count, count(lp) AS countlp, count(rc) AS countrc
        """)
    run_query(session, """
        MATCH (t1:Tag)<-[:HAS_TAG]-(:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_TAG]->(t2:Tag)
        WHERE NOT (c)-[:HAS_TAG]->(t1)
          AND t1 <> t2
        RETURN count(*) AS count
        """)
    run_query(session, """
        MATCH (country:Country)
        MATCH (pA:Person)-[:IS_LOCATED_IN]->(:City)-[:IS_PART_OF]->(country)
        MATCH (pB:Person)-[:IS_LOCATED_IN]->(:City)-[:IS_PART_OF]->(country)
        MATCH (pC:Person)-[:IS_LOCATED_IN]->(:City)-[:IS_PART_OF]->(country)
        MATCH (pA)-[k1:KNOWS]-(pB)-[k2:KNOWS]-(pC)-[k3:KNOWS]-(pa)
        RETURN count(*) AS count
        """)
    run_query(session, """
        MATCH
          (pA:Person)-[:KNOWS]-(pB:Person),
          (pA)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(pB)
        RETURN count(*) AS count
        """)
    run_query(session, """
        MATCH (person1:Person)-[:KNOWS]-(mutualFriend:Person)-[:KNOWS]-(person2:Person)-[:HAS_INTEREST]->(:Tag)
        WHERE person1 <> person2
          AND NOT (person1)-[:KNOWS]-(person2)
        RETURN count(*) AS count
        """)
    
driver.close()
