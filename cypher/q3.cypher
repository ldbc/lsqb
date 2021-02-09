MATCH (t1:Tag)<-[:HAS_TAG]-(:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_TAG]->(t2:Tag)
WHERE NOT (c)-[:HAS_TAG]->(t1)
  AND t1 <> t2
RETURN count(*) AS count
