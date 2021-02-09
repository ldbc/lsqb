MATCH
    (pA:Person)-[:KNOWS]-(pB:Person),
    (pA)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(pB)
RETURN count(*) AS count
